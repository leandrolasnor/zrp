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

      metrics << [:threat_count, threat.count]
      publish('metrics.fetched', payload: [metrics.last].to_h)

      metrics << [:hero_count, hero.count]
      publish('metrics.fetched', payload: [metrics.last].to_h)

      metrics << [:threats_grouped, threat.group(:rank, :status).count]
      publish('metrics.fetched', payload: [metrics.last].to_h)

      metrics << [:heroes_grouped, hero.group(:rank, :status).count]
      publish('metrics.fetched', payload: [metrics.last].to_h)

      metrics << [:average_score, battle.average(:score)]
      publish('metrics.fetched', payload: [metrics.last].to_h)

      metrics.to_h
    end
  end
end
