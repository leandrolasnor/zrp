# frozen_string_literal: true

class Ws::CreateThreat::Listeners::AllocateResource::Job
  include Dry.Types()
  extend Dry::Initializer

  option :transaction, type: Interface(:call), default: -> { AllocateResource::Transaction.new }, reader: :private
  option :allocate_resource_listener,
         type: Instance(Object),
         default: -> { Ws::CreateThreat::Listeners::AllocateResource::Listener.new }, reader: :private
  option :deallocate_resource_listener,
         type: Instance(Object),
         default: -> { Ws::CreateThreat::Listeners::DeallocateResource::Listener.new }, reader: :private
  option :scheduler, type: Instance(Proc), default: -> { proc { Resque.enqueue_at(_1, _2, _3) } }

  def call(threat_id)
    transaction.operations[:allocate].subscribe(allocate_resource_listener)
    transaction.operations[:allocate].subscribe(deallocate_resource_listener)

    ApplicationRecord.connection_pool.with_connection do
      transaction.call(threat_id) do
        _1.failure :find do |f|
          Rails.logger.error(f)
        end

        _1.failure :matches do |f|
          Rails.logger.error(f.message)
          scheduler.(1.minute.from_now, self.class, threat_id)
        end

        _1.failure :allocate do |f|
          Rails.logger.error(f.message)
          scheduler.(3.seconds.from_now, self.class, threat_id)
        end

        _1.failure do |f|
          Rails.logger.error(f.message)
        end

        _1.success {}
      end
    end
  end

  @queue = :matches
  def self.perform(threat_id)
    new.call(threat_id)
  end
end
