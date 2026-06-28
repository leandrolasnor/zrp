# frozen_string_literal: true

module HeroRemovedFromIndex
  class Subscriber
    extend Dry::Initializer

    param :event, reader: :private

    def self.call(event) = new(event).call

    def call
      Dashboard::Widgets::Job.enqueue(:heroes_working)
      Dashboard::Widgets::Job.enqueue(:heroes_distribution)
      RES.pub HeroRemovedFromIndex, "#{event[:model].demodulize}##{event[:id]}", event[:document].to_json
    end
  end
end
