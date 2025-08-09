# frozen_string_literal: true

module AllocateResource
  class Service
    extend Dry::Initializer

    param :threat_id, type: Types::Coercible::Integer, required: true, reader: :private
    option :transaction, type: Types::Interface(:call), default: -> { Transaction.new }, reader: :private

    def call
      ApplicationRecord.connection_pool.with_connection do
        ApplicationRecord.transaction do
          transaction.call(threat_id) do
            it.failure { |f| Rails.logger.error(f.message) }
            it.success {}
          end
        end
      end
    end
  end

  class Job < ApplicationJob
    queue_as :default
    def perform(threat_id) = Service.new(threat_id).call
  end
end
