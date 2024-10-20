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
      transaction.call(params) do
        _1.failure :validate do |f|
          raise StandardError.new(f.errors.to_h)
        end

        _1.failure :create do |f|
          raise StandardError.new(f.errors.to_h)
        end

        _1.success do |r|
          ::Rpc::Threat.new(name: r.name, rank: r.rank, status: r.status, lat: r.lat.to_f, lng: r.lng.to_f)
        end
      end
    end
  end
end
