# frozen_string_literal: true

class AllocateResource::Steps::Notify
  include Dry::Monads[:result]
  include Dry::Events::Publisher[:allocate_resource]

  register_event 'resource.allocated'
  register_event 'resource.not.allocated'

  def call(threat)
    publish('resource.allocated', threat: threat) if threat.working?
    publish('resource.not.allocated', threat: threat) if threat.enabled?
    threat
  end
end
