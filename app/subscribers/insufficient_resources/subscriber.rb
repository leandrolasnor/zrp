# frozen_string_literal: true

class InsufficientResources::Subscriber
  extend Dry::Initializer

  param :event, reader: :private

  def self.call(event) = new(event).call

  def call
    threat = event[:threat]

    Rails.cache.write('SNEAKERS_REQUEUE', true, expires_in: 1.minute)
    AllocateResource::Job.set(wait: 1.minute).perform_later(threat.id)
    Dashboard::Widgets::Job.enqueue(:heroes_distribution)
    RES.pub InsufficientResources, "#{threat.class.name.demodulize}##{threat.id}"
  end
end
