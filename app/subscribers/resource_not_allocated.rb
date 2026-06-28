# frozen_string_literal: true

module Subscribers
  class ResourceNotAllocated
    extend Dry::Initializer

    param :event, reader: :private

    def self.call(event) = new(event).call

    def call
      threat = event[:threat]

      AllocateResource::Job.perform_later(threat.id)
      Dashboard::Widgets::Job.enqueue(:heroes_distribution)
      RES.pub ResourceNotAllocated, "#{threat.class.name.demodulize}##{threat.id}", event[:matches_sorted].map(&:hero).to_json
    end
  end
end
