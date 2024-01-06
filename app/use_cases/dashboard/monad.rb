# frozen_string_literal: true

class Dashboard::Monad
  include Dry::Events::Publisher[:metrics_fetched]
  include Dry::Monads[:try]
  include Dry.Types()
  extend Dry::Initializer

  register_event('metrics.fetched')

  option :threat, type: Interface(:find), default: -> { Dashboard::Model::Threat }, reader: :private
  option :hero, type: Interface(:find), default: -> { Dashboard::Model::Hero }, reader: :private

  def call
    Try do
      publish('metrics.fetched', payload: { threat_count: threat.count })
      publish('metrics.fetched', payload: { hero_count: hero.count })
      publish('metrics.fetched', payload: { threats_grouped: threat.group(:rank, :status).count })
      publish('metrics.fetched', payload: { heroes_grouped: hero.group(:rank, :status).count })
    end
  end
end
