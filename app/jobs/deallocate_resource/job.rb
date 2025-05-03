# frozen_string_literal: true

module DeallocateResource
  class Service
    extend Dry::Initializer

    param :threat_id, type: Types::Integer, required: true, reader: :private
    option :monad, type: Types::Interface(:call), default: -> { Monad.new }, reader: :private
    option :listener, type: Types::Interface(:on_resource_deallocated), default: -> { Listener.new }, reader: :private

    def call
      monad.subscribe(listener)
      ApplicationRecord.connection_pool.with_connection do
        res = monad.call(threat_id)

        if res.failure?
          Rails.logger.error(res.exception)
          Job.perform_later(threat_id)
        end
      end
    end
  end

  class Job < ApplicationJob
    queue_as :default
    def perform(threat_id) = Service.new(threat_id).call
  end
end
