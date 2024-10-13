# frozen_string_literal: true

class Grpc::CreateThreat::Service < Grpc::ApplicationService
  option :monad, type: Interface(:call), default: -> { CreateThreat::Monad.new }, reader: :private
  option :listeners,
         type: Array,
         default: -> {
                    [
                      Grpc::CreateThreat::Listeners::AllocateResource::Listener.new,
                      Grpc::CreateThreat::Listeners::Dashboard::Widgets::ThreatsDisabled::Listener.new
                    ]
                  },
         reader: :private

  def call
    listeners.each { |listener| monad.subscribe(listener) }
    res = monad.(request.message.to_h)
    res.success? ? res.value! : error_handler
  end
end
