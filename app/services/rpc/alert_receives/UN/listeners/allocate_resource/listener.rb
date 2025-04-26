# frozen_string_literal: true

module Rpc::AlertReceives::UN::Listeners::AllocateResource
  class Listener
    def on_threat_created(e) = Resque.enqueue(Job, e[:threat].id)
    def on_resource_not_allocated(e) = Resque.enqueue_at(5.seconds.from_now, Job, e[:threat].id)
  end
end
