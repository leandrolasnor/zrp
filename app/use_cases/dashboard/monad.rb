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

      metrics << [:threat_count, threat.not_problem.count]
      publish('metrics.fetched', payload: [metrics.last].to_h)

      battle_count = threat.not_problem.not_enabled.count
      metrics << [:battle_count, battle_count]
      publish('metrics.fetched', payload: [metrics.last].to_h)

      metrics << [:hero_count, hero.not_disabled.count]
      publish('metrics.fetched', payload: [metrics.last].to_h)

      metrics << [:threats_grouped_rank_status, threat.group(:rank, :status).count]
      publish('metrics.fetched', payload: [metrics.last].to_h)

      metrics << [:threats_grouped_rank, threat.not_problem.group(:rank).count]
      publish('metrics.fetched', payload: [metrics.last].to_h)

      metrics << [:heroes_grouped_rank_status, hero.not_disabled.group(:rank, :status).count]
      publish('metrics.fetched', payload: [metrics.last].to_h)

      metrics << [:heroes_grouped_rank, hero.not_disabled.group(:rank).count]
      publish('metrics.fetched', payload: [metrics.last].to_h)

      metrics << [:average_score, battle.average(:score)&.round(2)]
      publish('metrics.fetched', payload: [metrics.last].to_h)

      battles_grouped_two_heroes = battle.group(:threat_id).having('count(*) = 2').count
      battles_two_heroes_count = battles_grouped_two_heroes.count
      battles_one_hero_count = battle_count - battles_two_heroes_count
      battles_two_and_one_percent = [
        ['One Hero', ((battles_one_hero_count.to_f / battle_count) * 100).round(2)],
        ['Two Heroes', ((battles_two_heroes_count.to_f / battle_count) * 100).round(2)]
      ]
      metrics << [:battles_two_and_one_percent, battles_two_and_one_percent]
      publish('metrics.fetched', payload: [metrics.last].to_h)

      metrics << [
        :average_time_to_match,
        ActiveSupport::Duration.build(
          threat.disabled.includes(:battles).average('battles.created_at - threats.created_at')
        ).parts
      ]
      publish('metrics.fetched', payload: [metrics.last].to_h)

      metrics.to_h
    end
  end
end
