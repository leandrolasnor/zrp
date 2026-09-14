# frozen_string_literal: true

module Dashboard::Widgets
  class Job < ApplicationJob
    WIDGETS = {
      super_hero: { event: 'WIDGET_SUPER_HERO_FETCHED', queue: :low_priority },
      average_score: { event: 'WIDGET_AVERAGE_SCORE_FETCHED', queue: :low_priority },
      average_time_to_match: { event: 'WIDGET_AVERAGE_TIME_TO_MATCH_FETCHED',  queue: :low_priority },
      battles_lineup: { event: 'WIDGET_BATTLES_LINEUP_FETCHED',         queue: :critical },
      heroes_working: { event: 'WIDGET_HEROES_WORKING_FETCHED',         queue: :critical },
      heroes_distribution: { event: 'WIDGET_HEROES_DISTRIBUTION_FETCHED', queue: :critical },
      threats_disabled: { event: 'WIDGET_THREATS_DISABLED_FETCHED', queue: :critical },
      threats_distribution: { event: 'WIDGET_THREATS_DISTRIBUTION_FETCHED', queue: :critical }
    }.freeze

    queue_as :low_priority

    unique :until_and_while_executing, lock_ttl: 5.seconds

    def perform(widget)
      redis = Redis.new(url: ENV.fetch('REDIS_URL', 'redis://localhost:6379/0'))
      config = self.class.widget_config(widget)
      monad = self.class.module_parent.const_get("#{widget.to_s.camelize}::Monad").new
      result = monad.call

      redis.publish('sse:widgets', { type: config[:event], payload: result.value! }.to_json) if result.success?
      Rails.logger.error(result.exception) if result.failure?
    ensure
      redis&.close
    end

    def self.widget_config(widget)
      WIDGETS[widget.to_sym] || raise(ArgumentError, "Unknown dashboard widget: #{widget}")
    end

    def self.enqueue(widget)
      config = widget_config(widget)
      set(queue: config[:queue]).perform_later(widget.to_s)
    end
  end
end
