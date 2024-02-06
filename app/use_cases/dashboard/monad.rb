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

  def call
    Try do
      metrics = []
      battle_count = 0
      REDIS.with do
        unless _1.get('threat_count')
          _1.set('threat_count', threat.fresh.not_problem.count)
          _1.expire('threat_count', 30)
        end
        metrics << [:threat_count, _1.get('threat_count')]
        publish('metrics.fetched', payload: [metrics.last].to_h)

        unless _1.get('battle_count')
          _1.set('battle_count', threat.fresh.not_problem.not_enabled.count)
          _1.expire('battle_count', 10)
        end
        battle_count = _1.get('battle_count').to_i
        metrics << [:battle_count, _1.get('battle_count')]
        publish('metrics.fetched', payload: [metrics.last].to_h)

        unless _1.get('hero_count')
          _1.set('hero_count', hero.not_disabled.count)
          _1.expire('hero_count', 10)
        end
        metrics << [:hero_count, _1.get('hero_count')]
        publish('metrics.fetched', payload: [metrics.last].to_h)

        unless _1.hgetall('threats_grouped_rank_status').presence
          _1.mapped_hmset(
            'threats_grouped_rank_status',
            threat.fresh.group(:rank, :status).count.transform_keys { |k| k.join('#') }
          )
          _1.expire('threats_grouped_rank_status', 10)
        end
        metrics << [:threats_grouped_rank_status, _1.hgetall('threats_grouped_rank_status')]
        publish('metrics.fetched', payload: [metrics.last].to_h)

        unless _1.hgetall('threats_grouped_rank').presence
          _1.mapped_hmset('threats_grouped_rank', threat.fresh.not_problem.group(:rank).count)
          _1.expire('threats_grouped_rank', 30)
        end
        metrics << [:threats_grouped_rank, _1.hgetall('threats_grouped_rank')]
        publish('metrics.fetched', payload: [metrics.last].to_h)

        unless _1.hgetall('heroes_grouped_rank_status').presence
          _1.mapped_hmset(
            'heroes_grouped_rank_status',
            hero.not_disabled.group(:rank, :status).count.transform_keys { |k| k.join('#') }
          )
          _1.expire('heroes_grouped_rank_status', 10)
        end
        metrics << [:heroes_grouped_rank_status, _1.hgetall('heroes_grouped_rank_status')]
        publish('metrics.fetched', payload: [metrics.last].to_h)

        unless _1.hgetall('heroes_grouped_rank').presence
          _1.mapped_hmset('heroes_grouped_rank', hero.not_disabled.group(:rank).count)
          _1.expire('heroes_grouped_rank', 10)
        end
        metrics << [:heroes_grouped_rank, _1.hgetall('heroes_grouped_rank')]
        publish('metrics.fetched', payload: [metrics.last].to_h)

        unless _1.get('average_score')
          _1.set('average_score', battle.fresh.average(:score)&.round(2))
          _1.expire('average_score', 30)
        end
        metrics << [:average_score, _1.get('average_score')]
        publish('metrics.fetched', payload: [metrics.last].to_h)

        unless _1.get('battles_two_heroes_count')
          _1.set('battles_two_heroes_count', battle.fresh.group(:threat_id).having('count(*) = 2').count.count)
          _1.expire('battles_two_heroes_count', 30)
        end
        battles_two_heroes_count = _1.get('battles_two_heroes_count').to_i
        battles_one_hero_count = battle_count - battles_two_heroes_count
        battles_two_and_one_percent = [
          ['One Hero', ((battles_one_hero_count.to_f / battle_count) * 100).round(2)],
          ['Two Heroes', ((battles_two_heroes_count.to_f / battle_count) * 100).round(2)]
        ]
        metrics << [:battles_two_and_one_percent, battles_two_and_one_percent]
        publish('metrics.fetched', payload: [metrics.last].to_h)
      end

      metrics << [
        :average_time_to_match,
        ActiveSupport::Duration.build(
          threat.fresh.disabled.includes(:battles).limit(25).average('battles.created_at - threats.created_at')
        ).parts
      ]
      publish('metrics.fetched', payload: [metrics.last].to_h)

      super_hero = hero.includes(:battles).where(
        'battles.finished_at': 45.minutes.ago...::Time.zone.now
      ).group(:name, :rank).sum(:score).max_by { _1.second }
      metrics << [:super_hero, super_hero.first]
      publish('metrics.fetched', payload: [metrics.last].to_h)

      metrics.to_h
    end
  end
end
