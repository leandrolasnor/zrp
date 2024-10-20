# frozen_string_literal: true

module Rpc::AlertReceives::UN::Listeners::AllocateResource
  class Listener
    def on_threat_created(e)
      Resque.enqueue(Job, e[:threat].id)
    end

    def on_resource_not_allocated(e)
      Resque.enqueue(Job, e[:threat].id)
    end
  end
end
