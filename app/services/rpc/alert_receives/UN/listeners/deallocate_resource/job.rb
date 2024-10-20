# frozen_string_literal: true

module Rpc::AlertReceives::UN
  class Listeners::DeallocateResource::Job
    include Dry.Types()
    extend Dry::Initializer

    option :monad, type: Interface(:call), default: -> { DeallocateResource::Monad.new }, reader: :private
    option :widget_heroes_working_listener,
           type: Interface(:on_resource_allocated),
           default: -> { Listeners::Dashboard::Widgets::HeroesWorking::Listener.new },
           reader: :private
    option :widget_threats_disabled_listener,
           type: Interface(:on_resource_deallocated),
           default: -> { Listeners::Dashboard::Widgets::ThreatsDisabled::Listener.new },
           reader: :private

    def call(threat_id)
      monad.subscribe(widget_heroes_working_listener)
      monad.subscribe(widget_threats_disabled_listener)

      ApplicationRecord.connection_pool.with_connection do
        res = monad.call(threat_id)

        if res.failure?
          Rails.logger.error(res.exception)
          Resque.enqueue(self.class, threat_id)
        end
      end
    end

    @queue = :allocated
    def self.perform(threat_id)
      new.call(threat_id)
    end

    private

    def queue_empty?
      Resque.size(:widget_heroes_working).zero?
    end
  end
end
