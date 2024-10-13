# frozen_string_literal: true

class Grpc::CreateThreat::Listeners::Dashboard::Widgets::ThreatsDisabled::Job
  include Dry.Types()
  extend Dry::Initializer

  option :monad, type: Interface(:call), default: -> { Dashboard::Widgets::ThreatsDisabled::Monad.new }, reader: :private
  option :event, type: Dry::Types['string'], default: -> { 'WIDGET_THREATS_DISABLED_FETCHED' }, reader: :private
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

  @queue = :widget_threats_disabled
  def self.perform
    new.call
  end
end
