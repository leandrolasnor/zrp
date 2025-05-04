# frozen_string_literal: true

module Rpc
  module AlertReceives::UN
    class Service < Rpc::ApplicationService
      option :transaction, type: Types::Interface(:call), default: -> {
        ::AlertReceives::UN::Transaction.new
      }, reader: :private

      def call
        transaction.call(params) do
          it.failure { |f| raise StandardError.new(f.errors) }
          it.success do |r|
            ::Rpc::Threat.new(
              status: r.status,
              name: r.name, rank: r.rank,
              lat: r.lat.to_f, lng: r.lng.to_f
            )
          end
        end
      end
    end
  end
end
