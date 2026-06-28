# frozen_string_literal: true

EVENTS = %w[
  insufficient_resources resource_allocated resource_not_allocated
  resource_deallocated threat_created hero_removed_from_index
].freeze

Rails.configuration.to_prepare do
  Dry::Events::Publisher.registry.clear
end

class AppEvents
  include Dry::Events::Publisher[:app]
  include Singleton

  def self.publish(...) = self.instance.publish(...)
  def self.subscribe(...) = self.instance.subscribe(...)

  EVENTS.each { register_event it }
end

EVENTS.each do |event_name|
  klass = "#{event_name.camelize}::Subscriber".constantize
  AppEvents.subscribe(event_name) { |event| klass.call(event) }
end
