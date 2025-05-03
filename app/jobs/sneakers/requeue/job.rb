# frozen_string_literal: true

module Sneakers::Requeue
  class Service
    extend Dry::Initializer

    param :metrics, type: Types::Hash, required: true, reader: :private
    option :heroes_working_percent, default: -> { metrics['global'].to_i }, reader: :private,
                                    type: Types::Coercible::Integer

    def call = REDIS.with { it.set('SNEAKERS_REQUEUE', heroes_working_percent >= ENV.fetch('HWP_LIMIT', 80).to_i) }
  end

  class Job < ApplicationJob
    queue_as :critical
    unique :until_and_while_executing, lock_ttl: 5.seconds
    def perform(metrics) = Service.new(metrics).call
  end
end
