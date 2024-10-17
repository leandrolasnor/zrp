# frozen_string_literal: true

class Grpc::CreateThreat::Listeners::Dashboard::Widgets::AverageTimeToMatch::Job
  include Dry.Types()
  extend Dry::Initializer

  option :monad, type: Interface(:call), default: -> { Dashboard::Widgets::AverageTimeToMatch::Monad.new }, reader: :private
  option :event, type: Dry::Types['string'], default: -> { 'WIDGET_AVERAGE_TIME_TO_MATCH_FETCHED' }, reader: :private
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

  @queue = :widget_average_time_to_match
  def self.perform
    new.call
  end
end
