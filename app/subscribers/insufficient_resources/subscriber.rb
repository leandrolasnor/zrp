# frozen_string_literal: true

module InsufficientResources
  class Subscriber
    extend Dry::Initializer

    param :event, reader: :private

    def self.call(event) = new(event).call

    def call
      threat = event[:threat]

      REDIS.with { |redis| redis.set('SNEAKERS_REQUEUE', true, ex: 60) }
      AllocateResource::Job.set(wait: 1.minute).perform_later(threat.id)
      Dashboard::Widgets::Job.enqueue(:heroes_distribution)
      RES.pub InsufficientResource, "#{threat.class.name.demodulize}##{threat.id}"
    end
  end
end
