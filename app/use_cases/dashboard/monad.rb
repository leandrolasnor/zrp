# frozen_string_literal: true

class Dashboard::Monad
  include Dry::Events::Publisher[:metrics_fetched]
  include Dry::Monads[:try]
  include Dry.Types()
  extend Dry::Initializer

  register_event('metrics.fetched')

  option :metrics,
         type: Array,
         default: -> {
                    [
                      Dashboard::Widgets::SuperHero::Monad,
                      Dashboard::Widgets::AverageScore::Monad,
                      Dashboard::Widgets::AverageTimeToMatch::Monad,
                      Dashboard::Widgets::HeroesWorking::Monad,
                      Dashboard::Widgets::ThreatsDisabled::Monad,
                      Dashboard::Widgets::BattlesLineup::Monad,
                      Dashboard::Widgets::ThreatsDistribution::Monad,
                      Dashboard::Widgets::HeroesDistribution::Monad
                    ]
                  },
         private: :reader

  def call
    Try do
      result = metrics.map do
        name = _1.name.split('::').third.underscore.to_sym
        res = _1.new.()
        payload = res.success? ? [name, res.value!] : [name, nil]
        publish('metrics.fetched', payload: [payload].to_h) if payload.second.present?
        payload
      end

      result.to_h
    end
  end
end
