# frozen_string_literal: true

module Dashboard::Widgets::HeroesWorking
  class Service
    extend Dry::Initializer

    option :monad, type: Types::Interface(:call), default: -> { Monad.new }, reader: :private
    option :event, type: Types::Coercible::String, default: -> { 'WIDGET_HEROES_WORKING_FETCHED' }, reader: :private
    option :identifier, type: Types::Coercible::String, default: -> { 'token' }, reader: :private
    option :broadcast,
           type: Types::Instance(Proc),
           default: -> { proc { ActionCable.server.broadcast(identifier, { type: event, payload: it }) } },
           reader: :private

    def call
      res = monad.()
      broadcast.(res.value!) if res.success?
      Rails.logger.error(res.exception) if res.failure?
    end
  end

  class Job < ApplicationJob
    queue_as :critical
    unique :until_and_while_executing, lock_ttl: 1.second
    def perform = Service.new.call
  end
end
