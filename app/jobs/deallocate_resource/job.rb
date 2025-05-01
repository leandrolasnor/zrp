# frozen_string_literal: true

module DeallocateResource
  class Job
    extend Dry::Initializer

    option :monad, type: Types::Interface(:call), default: -> { Monad.new }, reader: :private
    option :listener, type: Types::Interface(:on_resource_deallocated), default: -> { Listener.new }, reader: :private

    def call(threat_id)
      monad.subscribe(listener)
      ApplicationRecord.connection_pool.with_connection do
        res = monad.call(threat_id)

        if res.failure?
          Rails.logger.error(res.exception)
          Resque.enqueue(self.class, threat_id)
        end
      end
    end

    @queue = :allocated
    def self.perform(threat_id) = new.call(threat_id)
    include Resque::Plugins::UniqueByArity.new(
      arity_for_uniqueness: 1,
      unique_in_queue: true,
      unique_at_runtime: true
    )
  end
end
