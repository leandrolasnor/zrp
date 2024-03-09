# frozen_string_literal: true

class Ws::CreateThreat::Service < Ws::ApplicationService
  option :monad, type: Interface(:call), default: -> { CreateThreat::Monad.new }, reader: :private
  option :listeners,
         type: Array,
         default: -> { [Ws::CreateThreat::Listeners::AllocateResource::Listener.new] },
         reader: :private

  def call
    listeners.each { |listener| monad.subscribe(listener) }

    monad.call(params)
  end
end
