# frozen_string_literal: true

class UNThreatCreated::Subscriber
  extend Dry::Initializer

  param :event, reader: :private

  def self.call(event) = new(event).call

  def call
    threat = event[:threat]

    AllocateResource::Job.perform_later(threat.id)
    Dashboard::Widgets::Job.enqueue(:threats_disabled)
    Dashboard::Widgets::Job.enqueue(:threats_distribution)
    RES.pub UN::AlertReceived, "#{threat.class.name.demodulize}##{threat.id}", threat.payload
  end
end
