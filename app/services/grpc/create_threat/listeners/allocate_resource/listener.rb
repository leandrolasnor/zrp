# frozen_string_literal: true

class Grpc::CreateThreat::Listeners::AllocateResource::Listener
  def on_threat_created(e)
    Resque.enqueue(Grpc::CreateThreat::Listeners::AllocateResource::Job, e[:threat].id)
  end

  def on_resource_not_allocated(e)
    Resque.enqueue(Grpc::CreateThreat::Listeners::AllocateResource::Job, e[:threat].id)
  end
end
