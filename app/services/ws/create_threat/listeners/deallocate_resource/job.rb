# frozen_string_literal: true

class Ws::CreateThreat::Listeners::DeallocateResource::Job
  include Dry.Types()
  extend Dry::Initializer

  option :monad, type: Interface(:call), default: -> { DeallocateResource::Monad.new }, reader: :private

  def call(threat_id)
    ApplicationRecord.connection_pool.with_connection do
      res = monad.call(threat_id)

      if res.failure?
        Rails.logger.error(res.exception)
        Resque.enqueue(Ws::CreateThreat::DeallocateResource::Job, threat_id)
      end
    end
  end

  @queue = :allocated
  def self.perform(threat_id)
    new.call(threat_id)
  end
end
