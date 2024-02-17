# frozen_string_literal: true

class Dashboard::Monad
  include Dry::Events::Publisher[:metrics_fetched]
  include Dry::Monads[:try]
  include Dry.Types()
  extend Dry::Initializer

  register_event('metrics.fetched')

  option :threat, type: Interface(:find), default: -> { Dashboard::Model::Threat }, reader: :private
  option :hero, type: Interface(:find), default: -> { Dashboard::Model::Hero }, reader: :private
  option :battle, type: Interface(:find), default: -> { Dashboard::Model::Battle }, reader: :private
  option :duration, type: Instance(Proc), default: -> { proc { ActiveSupport::Duration.build(_1).parts } }

  def call
    Try do
      metrics = []

      metrics << [
        :threat_count,
        Rails.cache.fetch('threat_count', expires_in: 30.seconds) do
          threat.ms_raw_search(
            '',
            page: 0,
            filter: [
              "created_at > #{20.minutes.ago.to_time.to_i}",
              'status != problem'
            ]
          )['totalHits']
        end
      ]
      publish('metrics.fetched', payload: [metrics.last].to_h)

      metrics << [
        :battle_count,
        Rails.cache.fetch('battle_count', expires_in: 10.seconds) do
          # threat.fresh.not_problem.not_enabled.count
          threat.ms_raw_search(
            '',
            page: 0,
            filter: [
              "created_at > #{20.minutes.ago.to_time.to_i}",
              'status IN [working, disabled]'
            ]
          )['totalHits']
        end
      ]
      publish('metrics.fetched', payload: [metrics.last].to_h)

      metrics << [
        :hero_count,
        Rails.cache.fetch('hero_count', expires_in: 10.seconds) do
          # hero.not_disabled.count
          hero.ms_raw_search(
            '',
            page: 0,
            filter: ['status != disabled']
          )['totalHits']
        end
      ]
      publish('metrics.fetched', payload: [metrics.last].to_h)

      metrics << [
        :threats_grouped_rank_status,
        Rails.cache.fetch('threats_grouped_rank_status', expires_in: 10.seconds) do
          # threat.fresh.group(:rank, :status).count.transform_keys { |k| k.join('#') }
          threat.ms_raw_search(
            '',
            page: 0,
            facets: [:rank, :status]
          )
        end
      ]
      publish('metrics.fetched', payload: [metrics.last].to_h)

      metrics << [
        :threats_grouped_rank,
        Rails.cache.fetch('threats_grouped_rank', expires_in: 30.seconds) do
          threat.fresh.not_problem.group(:rank).count
        end
      ]
      publish('metrics.fetched', payload: [metrics.last].to_h)

      metrics << [
        :heroes_grouped_rank_status,
        Rails.cache.fetch('heroes_grouped_rank_status', expires_in: 10.seconds) do
          hero.not_disabled.group(:rank, :status).count.transform_keys { |k| k.join('#') }
        end
      ]
      publish('metrics.fetched', payload: [metrics.last].to_h)

      metrics << [
        :heroes_grouped_rank,
        Rails.cache.fetch('heroes_grouped_rank', expires_in: 10.seconds) do
          hero.not_disabled.group(:rank).count
        end
      ]
      publish('metrics.fetched', payload: [metrics.last].to_h)

      metrics << [
        :average_score,
        Rails.cache.fetch('average_score', expires_in: 30.seconds) do
          battle.fresh.average(:score)&.round(2)
        end
      ]
      publish('metrics.fetched', payload: [metrics.last].to_h)

      metrics << [
        :battles_two_and_one_percent,
        Rails.cache.fetch('battles_two_and_one_percent', expires_in: 30.seconds) do
          battles_two_heroes_count = battle.fresh.group(:threat_id).having('count(*) = 2').count.count
          battle_count = Rails.cache.fetch('battle_count')
          battles_one_hero_count = battle_count - battles_two_heroes_count
          [
            ['One Hero', ((battles_one_hero_count.to_f / battle_count) * 100).round(2)],
            ['Two Heroes', ((battles_two_heroes_count.to_f / battle_count) * 100).round(2)]
          ]
        end
      ]
      publish('metrics.fetched', payload: [metrics.last].to_h)

      metrics << [
        :average_time_to_match,
        Rails.cache.fetch('average_time_to_match', expires_in: 30.seconds) do
          duration.(threat.fresh.disabled
            .includes(:battles)
            .limit(25)
            .average('battles.created_at - threats.created_at'))
        end
      ]
      publish('metrics.fetched', payload: [metrics.last].to_h)

      metrics << [
        :super_hero,
        Rails.cache.fetch('super_hero', expires_in: 30.seconds) do
          name, rank = hero.includes(:battles)
            .where('battles.finished_at': 20.minutes.ago...::Time.zone.now)
            .group(:name, :rank).sum(:score).max_by(&:second)&.first
          { name: name, rank: rank }
        end
      ]
      publish('metrics.fetched', payload: [metrics.last].to_h)
      metrics.to_h
    end
  end
end
