# frozen_string_literal: true

module Dashboard
  class Monad
    include Dry::Monads[:try]
    extend Dry::Initializer

    option :metrics,
           type: Types::Array,
           default: -> {
                      [
                        Widgets::SuperHero::Monad.new,
                        Widgets::AverageScore::Monad.new,
                        Widgets::AverageTimeToMatch::Monad.new,
                        Widgets::HeroesWorking::Monad.new,
                        Widgets::ThreatsDisabled::Monad.new,
                        Widgets::BattlesLineup::Monad.new,
                        Widgets::ThreatsDistribution::Monad.new,
                        Widgets::HeroesDistribution::Monad.new
                      ]
                    },
           private: :reader

    def call
      Try do
        result = metrics.map do
          name = it.class.name.split('::').third.underscore.to_sym
          res = it.call
          payload = res.success? ? [name, res.value!] : [name, nil]
          AppEvents.publish('metrics.fetched', [payload].to_h) if payload.second.present?
          payload
        end

        result.to_h
      end
    end
  end
end
