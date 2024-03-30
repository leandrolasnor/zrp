# frozen_string_literal: true

class Ws::CreateThreat::Listeners::DeallocateResource::Listener
  def on_resource_allocated(e)
    Resque.enqueue_at(
      e[:threat].battles.first.finished_at,
      Ws::CreateThreat::Listeners::DeallocateResource::Job,
      e[:threat].id
    )
  end
end
