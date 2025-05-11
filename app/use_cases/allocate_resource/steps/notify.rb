# frozen_string_literal: true

class AllocateResource::Steps::Notify
  def call(threat)
    AppEvents.publish('resource.allocated', threat:) if threat.working?
    AppEvents.publish('resource.not.allocated', threat:) if threat.enabled?
    threat
  end
end
