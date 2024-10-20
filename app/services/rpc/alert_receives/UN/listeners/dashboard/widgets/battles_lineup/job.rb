# frozen_string_literal: true

module Rpc::AlertReceives::UN::Listeners::Dashboard::Widgets::BattlesLineup
  class Job
    include Dry.Types()
    extend Dry::Initializer

    option :monad, type: Interface(:call), default: -> {
      Dashboard::Widgets::BattlesLineup::Monad.new
    }, reader: :private
    option :event, type: Dry::Types['string'], default: -> { 'WIDGET_BATTLES_LINEUP_FETCHED' }, reader: :private
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

    @queue = :widget_battles_lineup
    def self.perform
      new.call
    end
  end
end
