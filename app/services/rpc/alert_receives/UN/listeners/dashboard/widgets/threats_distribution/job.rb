# frozen_string_literal: true

module Rpc::AlertReceives::UN::Listeners::Dashboard::Widgets::ThreatsDistribution
  class Job
    include Dry.Types()
    extend Dry::Initializer

    option :monad, type: Interface(:call), default: -> {
      Dashboard::Widgets::ThreatsDistribution::Monad.new
    }, reader: :private
    option :event, type: Dry::Types['string'], default: -> { 'WIDGET_THREATS_DISTRIBUTION_FETCHED' }, reader: :private
    option :identifier, type: Dry::Types['string'], default: -> { 'token' }, reader: :private
    option :broadcast,
           type: Instance(Proc),
           default: -> { proc { ActionCable.server.broadcast(identifier, { type: event, payload: _1 }) } },
           reader: :private

    def call
      res = monad.()
      broadcast.(res.value!) if res.success?
      Rails.logger.error(res.exception) if res.failure?
    end

    @queue = :widget_threats_distribution
    def self.perform = new.call
    include Resque::Plugins::UniqueByArity.new(
      lock_after_execution_period: 1, # seconds
      unique_at_runtime: true,
      unique_in_queue: true
    )
  end
end
