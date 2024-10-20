# frozen_string_literal: true

module Rpc::AlertReceives::UN
  class Service < Rpc::ApplicationService
    option :transaction, type: Interface(:call), default: -> { AlertReceives::UN::Transaction.new }, reader: :private
    option :listeners,
           type: Array,
           reader: :private,
           default: -> {
             [
               Listeners::AllocateResource::Listener.new,
               Listeners::Dashboard::Widgets::ThreatsDisabled::Listener.new
             ]
           }

    def call
      listeners.each { transaction.operations[:notify].subscribe _1 }
      res = transaction.(params)
      debugger
      raise res.exception if res.failure?

      ::Rpc::Threat.new(
        name: res.value!.name,
        rank: res.value!.rank,
        status: res.value!.status,
        lat: res.value!.lat.to_s,
        lng: res.value!.lng.to_s
      )
    end
  end
end
