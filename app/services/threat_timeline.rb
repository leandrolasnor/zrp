# frozen_string_literal: true

# Reads the Rails Event Store streams of the given threats (Threat#<id>) and
# turns them into a compact timeline to be serialized with the threat history.
class ThreatTimeline
  STREAM_PREFIX = 'Threat#'.freeze

  TITLES = {
    'UN::AlertReceived' => 'Threat detected',
    'InsufficientResources' => 'Insufficient resources',
    'ResourceAllocated' => 'Heroes allocated',
    'ResourceNotAllocated' => 'No hero available',
    'ResourceDeallocated' => 'Heroes deallocated'
  }.freeze

  EVENTS_SQL = <<~SQL.squish
    SELECT s.stream, e.event_type, e.data, e.created_at, e.event_id
    FROM event_store_events_in_streams s
    JOIN event_store_events e ON e.event_id = s.event_id
    WHERE s.stream IN (?)
    ORDER BY e.created_at ASC, e.event_id ASC
  SQL

  def self.call(threat_ids, connection: ActiveRecord::Base.connection)
    new(threat_ids, connection: connection).call
  end

  def initialize(threat_ids, connection:)
    @streams = Array(threat_ids).compact.uniq.map { |id| "#{STREAM_PREFIX}#{id}" }
    @connection = connection
  end

  def call
    return {} if @streams.empty?

    rows = @connection.select_all(ActiveRecord::Base.sanitize_sql_array([EVENTS_SQL, @streams]))

    rows.each_with_object(Hash.new { |hash, key| hash[key] = [] }) do |row, timeline|
      id = row.fetch('stream').to_s[/Threat#(\d+)/, 1]&.to_i
      next unless id

      timeline[id] << serialize(row)
    end
  end

  private

  def serialize(row)
    type = row.fetch('event_type')

    {
      id: row.fetch('event_id'),
      type: type.demodulize,
      title: TITLES.fetch(type, type),
      occurred_at: timestamp(row['created_at']),
      details: details(type, parse(row['data']))
    }
  end

  def timestamp(value)
    return if value.nil?

    value.respond_to?(:iso8601) ? value.iso8601 : Time.zone.parse(value.to_s)&.iso8601
  rescue ArgumentError
    nil
  end

  def parse(data)
    return data unless data.is_a?(String)

    JSON.parse(data)
  rescue JSON::ParserError
    {}
  end

  def details(type, data)
    case type
    when 'UN::AlertReceived'
      data.is_a?(Hash) ? data.slice('name', 'monsterName', 'rank', 'dangerLevel', 'location') : {}
    when 'ResourceAllocated', 'ResourceDeallocated'
      allocated_details(data)
    when 'ResourceNotAllocated'
      data.is_a?(Array) ? data.filter_map { |hero| hero.slice('name', 'rank') if hero.is_a?(Hash) } : {}
    else
      {}
    end
  end

  def allocated_details(data)
    return {} unless data.is_a?(Hash)

    {
      heroes: Array(data['heroes']).filter_map { |hero| hero.slice('name', 'rank') if hero.is_a?(Hash) },
      battles: Array(data['battles']).filter_map { |battle| battle.slice('score', 'finished_at') if battle.is_a?(Hash) }
    }
  end
end
