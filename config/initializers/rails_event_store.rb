# frozen_string_literal: true

Rails.configuration.to_prepare do
  Rails.configuration.event_store = RailsEventStore::JSONClient.new
end

class RES
  include Singleton

  def self.pub(...) = instance.pub(...)

  def pub(e, s, p = nil) = Rails.configuration.event_store.publish(
    e.new(data: p),
    stream_name: s
  )
end

class HeroRemovedFromIndex < RailsEventStore::Event; end
class InsufficientResources < RailsEventStore::Event; end
class ResourceAllocated < RailsEventStore::Event; end
class ResourceDeallocated < RailsEventStore::Event; end
class ResourceNotAllocated < RailsEventStore::Event; end
module UN
  class AlertReceived < RailsEventStore::Event; end
end
