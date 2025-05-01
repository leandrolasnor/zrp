# frozen_string_literal: true

module Dashboard::Widgets::HeroesDistribution
  class Job
    extend Dry::Initializer

    option :monad, type: Types::Interface(:call), default: -> { Monad.new }, reader: :private
    option :event, type: Types::String, default: -> { 'WIDGET_HEROES_DISTRIBUTION_FETCHED' }, reader: :private
    option :identifier, type: Types::String, default: -> { 'token' }, reader: :private
    option :broadcast,
           type: Types::Instance(Proc),
           default: -> { proc { ActionCable.server.broadcast(identifier, { type: event, payload: it }) } },
           reader: :private

    def call
      res = monad.()
      broadcast.(res.value!) if res.success?
      Rails.logger.error(res.exception) if res.failure?
    end

    @queue = :widget_heroes_distribution
    def self.perform(...) = new(...).call
    include Resque::Plugins::UniqueByArity.new(
      unique_at_runtime: true,
      unique_in_queue: true
    )
  end
end
