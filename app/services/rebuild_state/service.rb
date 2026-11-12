# frozen_string_literal: true

require 'json'

module RebuildState
  class Service
    HERO_ATTRIBUTES = %i[name rank status lat lng deleted_at created_at updated_at].freeze
    THREAT_ATTRIBUTES = %i[name rank lat lng payload created_at updated_at].freeze

    EVENTS_SQL = <<~SQL.squish
      SELECT e.event_type, e.data, e.event_id, s.stream
      FROM event_store_events e
      LEFT JOIN event_store_events_in_streams s ON s.event_id = e.event_id
      ORDER BY e.created_at ASC, e.event_id ASC
    SQL

    def self.call = new.call

    def call
      ActiveRecord::Base.transaction do
        reset_tables
        replay
      end
    end

    class Hero < ApplicationRecord
      include Enums::Hero::Rank
      include Enums::Hero::Status
    end

    class Threat < ApplicationRecord
      include Enums::Threat::Rank
      include Enums::Threat::Status
    end

    class Battle < ApplicationRecord
      belongs_to :hero, optional: true
      belongs_to :threat, optional: true
    end

    private

    def reset_tables
      Battle.delete_all
      Hero.delete_all
      Threat.delete_all
    end

    def replay
      ActiveRecord::Base.connection.select_all(EVENTS_SQL).each do |row|
        data = row['data']
        data = JSON.parse(data) if data.is_a?(String)
        project(row['event_type'], data, row['stream'])
      end
    end

    def project(type, data, stream)
      case type
      when 'HeroCreated', 'HeroUpdated', 'HeroDestroyed' then apply_hero(data)
      when 'UN::AlertReceived' then create_threat_from_alert(data, stream)
      when 'ResourceAllocated' then apply_allocated(data, stream)
      when 'ResourceDeallocated' then apply_deallocated(data, stream)
      end
    end

    def apply_hero(data)
      return unless data.is_a?(Hash)

      hero = Hero.find_or_initialize_by(id: value(data, :id))
      assign(hero, data, HERO_ATTRIBUTES)
      hero.save!(validate: false)
    end

    def create_threat_from_alert(data, stream)
      threat = Threat.find_or_initialize_by(id: extract_id(stream, 'Threat'))
      apply_alert(threat, parse(data))
      threat.save!(validate: false)
    end

    def apply_alert(threat, parsed)
      location = parsed['location'] || {}

      assign_alert_identity(threat, parsed, location)
      assign_alert_metadata(threat, parsed)
    end

    def assign_alert_identity(threat, parsed, location)
      name = parsed['name'] || parsed['monsterName']
      threat.name = name if name
      threat.rank = normalize_rank(parsed['rank'] || parsed['dangerLevel'])
      threat.lat = parsed['lat'] || location['lat']
      threat.lng = parsed['lng'] || location['lng']
    end

    def assign_alert_metadata(threat, parsed)
      threat.status = parsed.key?('status') ? parsed['status'] : 1
      threat.payload = parsed.to_json
      threat.created_at = parsed['created_at'] if parsed.key?('created_at')
      threat.updated_at = parsed['updated_at'] if parsed.key?('updated_at')
    end

    def apply_allocated(data, stream)
      return unless data.is_a?(Hash)

      threat_id = threat_id_for(data, stream)
      threat = Threat.find_or_initialize_by(id: threat_id)
      assign_threat(threat, value(data, :threat))
      threat.status = value(value(data, :threat), :status) || 3
      threat.save!(validate: false)

      upsert_heroes(data, default_status: 2)
      upsert_battles(data, threat_id)
    end

    def apply_deallocated(data, stream)
      return unless data.is_a?(Hash)

      threat_id = threat_id_for(data, stream)
      threat = Threat.find_or_initialize_by(id: threat_id)
      assign_threat(threat, value(data, :threat))
      threat.status = value(value(data, :threat), :status) || 2
      threat.save!(validate: false)

      upsert_heroes(data, default_status: 1)
      update_battles(data, threat_id)
    end

    def threat_id_for(data, stream)
      value(value(data, :threat), :id) || extract_id(stream, 'Threat')
    end

    def upsert_heroes(data, default_status:)
      Array(value(data, :heroes)).each do |hero_data|
        hero = Hero.find_or_initialize_by(id: value(hero_data, :id))
        assign_hero(hero, hero_data)
        hero.status = value(hero_data, :status) || default_status
        hero.save!(validate: false)
      end
    end

    def upsert_battles(data, threat_id)
      Array(value(data, :battles)).each do |battle_data|
        battle_id = value(battle_data, :id)
        battle = battle_id ? Battle.find_or_initialize_by(id: battle_id) : Battle.new
        battle.score = value(battle_data, :score)
        battle.hero_id = value(battle_data, :hero_id)
        battle.threat_id = value(battle_data, :threat_id) || threat_id
        battle.finished_at = value(battle_data, :finished_at)
        battle.save!(validate: false)
      end
    end

    def update_battles(data, threat_id)
      Array(value(data, :battles)).each do |battle_data|
        battle_id = value(battle_data, :id)
        next unless battle_id

        battle = Battle.find_or_initialize_by(id: battle_id)
        battle.score = value(battle_data, :score) if key?(battle_data, :score)
        battle.hero_id = value(battle_data, :hero_id) if key?(battle_data, :hero_id)
        battle.threat_id = value(battle_data, :threat_id) || threat_id
        battle.finished_at = value(battle_data, :finished_at) if key?(battle_data, :finished_at)
        battle.save!(validate: false)
      end
    end

    def assign_hero(hero, data)
      return unless data.is_a?(Hash)

      assign(hero, data, HERO_ATTRIBUTES)
    end

    def assign_threat(threat, data)
      return unless data.is_a?(Hash)

      assign(threat, data, THREAT_ATTRIBUTES)
    end

    def assign(record, data, keys)
      keys.each do |key|
        record.public_send("#{key}=", value(data, key)) if key?(data, key)
      end
    end

    def value(data, key)
      return nil unless data.is_a?(Hash)

      data[key.to_s] || data[key.to_sym]
    end

    def key?(data, key)
      data.is_a?(Hash) && (data.key?(key.to_s) || data.key?(key.to_sym))
    end

    def parse(data)
      return data if data.is_a?(Hash)
      return {} unless data.is_a?(String)

      JSON.parse(data)
    rescue JSON::ParserError
      {}
    end

    def normalize_rank(rank)
      rank.is_a?(String) ? rank.downcase : rank
    end

    def extract_id(stream, prefix)
      return nil unless stream.is_a?(String)

      match = stream.match(/#{prefix}#(\d+)/)
      match[1].to_i if match
    end
  end

  def self.call = Service.call
end

ReplayEvents = RebuildState
EventReplay = RebuildState
ProjectionReplay = RebuildState
RebuildStateService = RebuildState
RebuildService = RebuildState
