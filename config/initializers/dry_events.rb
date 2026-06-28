# frozen_string_literal: true

Rails.configuration.to_prepare do
  Dry::Events::Publisher.registry.clear
end

class AppEvents
  include Dry::Events::Publisher[:app]
  include Singleton

  def self.publish(...) = self.instance.publish(...)
  def self.subscribe(...) = self.instance.subscribe(...)

  EVENTS = %W[
    insufficient_resources resource_allocated resource_not_allocated
    resource_deallocated threat_created hero_removed_from_index
  ].freeze

  EVENTS.each { register_event it }
end

AppEvents::EVENTS.each do |event_name|
  klass = "Subscribers::#{event_name.camelize}".constantize
  AppEvents.subscribe(event_name) { |event| klass.call(event) }
end
