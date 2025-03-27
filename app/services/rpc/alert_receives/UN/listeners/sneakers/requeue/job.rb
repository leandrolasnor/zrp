# frozen_string_literal: true

module Rpc::AlertReceives::UN::Listeners::Sneakers::Requeue
  class Job
    def call(metrics)
      REDIS.with do
        heroes_working_percent = metrics[:global].to_i
        heroes_working_percent_limit = ENV.fetch('HWP_LIMIT', 80).to_i
        _1.set('SNEAKERS_REQUEUE', heroes_working_percent >= heroes_working_percent_limit)
      end
    end

    @queue = :sneakers_requeue
    def self.perform(params) = new.call(params.deep_symbolize_keys)
    include Resque::Plugins::UniqueByArity.new(
      lock_after_execution_period: 5, # seconds
      unique_at_runtime: true,
      unique_in_queue: true
    )
  end
end
