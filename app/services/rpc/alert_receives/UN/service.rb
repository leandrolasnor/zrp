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
               Listeners::Dashboard::Widgets::ThreatsDisabled::Listener.new,
               Listeners::Dashboard::Widgets::ThreatsDistribution::Listener.new
             ]
           }

    def call
      listeners.each { transaction.operations[:notify].subscribe it }
      transaction.call(params) do
        it.failure :validate do |f|
          raise StandardError.new(f.errors)
        end

        it.failure :create do |f|
          raise StandardError.new(f.errors)
        end

        it.success do |r|
          ::Rpc::Threat.new(name: r.name, rank: r.rank, status: r.status, lat: r.lat.to_f, lng: r.lng.to_f)
        end
      end
    end
  end
end
