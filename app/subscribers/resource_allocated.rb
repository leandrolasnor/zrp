# frozen_string_literal: true

module Subscribers
  class ResourceAllocated
    extend Dry::Initializer

    param :event, reader: :private

    def self.call(event) = new(event).call

    def call
      threat = event[:threat]

      DeallocateResource::Job.
        set(wait_until: threat.battles.first.finished_at).
        perform_later(threat.id)
      Dashboard::Widgets::Job.enqueue(:average_score)
      Dashboard::Widgets::Job.enqueue(:average_time_to_match)
      Dashboard::Widgets::Job.enqueue(:battles_lineup)
      Dashboard::Widgets::Job.enqueue(:heroes_working)
      Dashboard::Widgets::Job.enqueue(:super_hero)
      RES.pub ResourceAllocated, "#{threat.class.name.demodulize}##{threat.id}", threat.heroes.to_json
    end
  end
end
