# frozen_string_literal: true

module AllocateResource
  class Service
    extend Dry::Initializer

    param :threat_id, type: Types::Coercible::Integer, required: true, reader: :private
    option :transaction, type: Types::Interface(:call), default: -> { Transaction.new }, reader: :private
    option :listener, default: -> { Listener.new }, reader: :private,
                      type: Types::Interface(
                        :on_resource_not_allocated,
                        :on_insufficient_resources,
                        :on_resource_allocated
                      )

    def call
      transaction.operations[:notify].subscribe(listener)
      transaction.operations[:matches].subscribe(listener)
      ApplicationRecord.connection_pool.with_connection do
        transaction.call(threat_id) do
          it.failure { |f| Rails.logger.error(f.message) }
          it.success {}
        end
      end
    end
  end

  class Job < ApplicationJob
    queue_as :default
    def perform(threat_id) = Service.new(threat_id).call
  end
end
