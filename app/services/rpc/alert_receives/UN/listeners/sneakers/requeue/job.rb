# frozen_string_literal: true

module Rpc::AlertReceives::UN::Listeners::Sneakers::Requeue
  class Job
    def call(busy) = REDIS.with { it.set('SNEAKERS_REQUEUE', busy >= ENV.fetch('HWP_LIMIT', 80).to_i) }

    @queue = :sneakers_requeue
    def self.perform(metrics) = new.call(metrics['global'].to_i)
    include Resque::Plugins::UniqueByArity.new(
      arity_for_uniqueness: 1,
      unique_at_runtime: true,
      unique_in_queue: true
    )
  end
end
