# frozen_string_literal: true

class AllocateResource::Steps::Notify
  include Dry::Monads[:result]

  def call(threat)
    AppEvents.publish('resource.allocated', threat:) if threat.working?
    AppEvents.publish('resource.not.allocated', threat:) if threat.enabled?
    threat
  end
end
