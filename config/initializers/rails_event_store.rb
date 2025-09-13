# frozen_string_literal: true

Rails.configuration.to_prepare do
  Rails.configuration.event_store = RailsEventStore::JSONClient.new
  AggregateRoot.configure { it.default_event_store = Rails.configuration.event_store }
  # add subscribers here
end
