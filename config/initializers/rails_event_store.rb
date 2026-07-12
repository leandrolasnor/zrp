# frozen_string_literal: true

Rails.configuration.to_prepare do
  Rails.configuration.event_store = RailsEventStore::JSONClient.new
end

class RES
  include Singleton

  def self.client = self.instance.client
  def client = Rails.configuration.event_store
  def self.pub(...) = self.instance.pub(...)
  def pub(e, s, p = nil) = client.publish(e.new(data: p), stream_name: s)
end

class HeroRemovedFromIndex < RailsEventStore::Event; end
class InsufficientResources < RailsEventStore::Event; end
class ResourceAllocated < RailsEventStore::Event; end
class ResourceDeallocated < RailsEventStore::Event; end
class ResourceNotAllocated < RailsEventStore::Event; end
module UN
  class AlertReceived < RailsEventStore::Event; end
end
