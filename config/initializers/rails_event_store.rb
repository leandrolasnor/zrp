# frozen_string_literal: true

Rails.configuration.to_prepare do
  Rails.configuration.event_store = RailsEventStore::JSONClient.new
  AggregateRoot.configure { it.default_event_store = Rails.configuration.event_store }
end

class RES
  include Singleton
  def self.client = self.instance.client
  def client = Rails.configuration.event_store
  def self.pub(...) = self.instance.pub(...)
  def pub(e, s, p = nil) = client.publish(e.new(data: p), stream_name: s)
end
