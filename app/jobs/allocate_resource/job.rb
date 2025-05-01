# frozen_string_literal: true

module AllocateResource
  class Job
    extend Dry::Initializer

    option :transaction, type: Types::Interface(:call), default: -> { Transaction.new }, reader: :private
    option :listener, default: -> { Listener.new }, reader: :private,
                      type: Types::Interface(
                        :on_resource_not_allocated,
                        :on_insufficient_resources,
                        :on_resource_allocated
                      )

    def call(threat_id)
      transaction.operations[:notify].subscribe(listener)
      transaction.operations[:matches].subscribe(listener)
      ApplicationRecord.connection_pool.with_connection do
        transaction.call(threat_id) do
          it.failure { |f| Rails.logger.error(f.message) }
          it.success {}
        end
      end
    end

    @queue = :matches
    def self.perform(threat_id) = new.call(threat_id)
  end
end
