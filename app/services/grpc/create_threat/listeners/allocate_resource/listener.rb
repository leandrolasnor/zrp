# frozen_string_literal: true

class Grpc::CreateThreat::Listeners::AllocateResource::Listener
  def on_threat_created(e)
    Rails.cache.increment(:threat_count, 1, expires_in: 30.seconds)
    Resque.enqueue(Ws::CreateThreat::Listeners::AllocateResource::Job, e[:threat].id)
  end

  def on_resource_not_allocated(e)
    Resque.enqueue(Ws::CreateThreat::Listeners::AllocateResource::Job, e[:threat].id)
  end
end
