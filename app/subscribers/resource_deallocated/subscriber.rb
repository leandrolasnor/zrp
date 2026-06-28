# frozen_string_literal: true

class ResourceDeallocated::Subscriber
  extend Dry::Initializer

  param :event, reader: :private

  def self.call(event) = new(event).call

  def call
    threat = event[:threat]

    Dashboard::Widgets::Job.enqueue(:heroes_working)
    Dashboard::Widgets::Job.enqueue(:threats_disabled)
    RES.pub ResourceDeallocated, "#{threat.class.name.demodulize}##{threat.id}", threat.heroes.to_json
  end
end
