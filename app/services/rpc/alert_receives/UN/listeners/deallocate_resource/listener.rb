# frozen_string_literal: true

module Rpc::AlertReceives::UN::Listeners::DeallocateResource
  class Listener
    def on_resource_allocated(e)
      Resque.enqueue_at(e[:threat].battles.first.finished_at, Job, e[:threat].id)
    end
  end
end
