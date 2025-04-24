# frozen_string_literal: true

class Dashboard::Monad
  include Dry::Events::Publisher[:metrics_fetched]
  include Dry::Monads[:try]
  extend Dry::Initializer

  register_event('metrics.fetched')

  option :metrics,
         type: Types::Array,
         default: -> {
                    [
                      Dashboard::Widgets::SuperHero::Monad.new,
                      Dashboard::Widgets::AverageScore::Monad.new,
                      Dashboard::Widgets::AverageTimeToMatch::Monad.new,
                      Dashboard::Widgets::HeroesWorking::Monad.new,
                      Dashboard::Widgets::ThreatsDisabled::Monad.new,
                      Dashboard::Widgets::BattlesLineup::Monad.new,
                      Dashboard::Widgets::ThreatsDistribution::Monad.new,
                      Dashboard::Widgets::HeroesDistribution::Monad.new
                    ]
                  },
         private: :reader

  def call
    Try do
      result = metrics.map do
        name = it.class.name.split('::').third.underscore.to_sym
        res = it.()
        payload = res.success? ? [name, res.value!] : [name, nil]
        publish('metrics.fetched', payload: [payload].to_h) if payload.second.present?
        payload
      end

      result.to_h
    end
  end
end
