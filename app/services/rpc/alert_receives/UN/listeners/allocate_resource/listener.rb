# frozen_string_literal: true

module Rpc::AlertReceives::UN::Listeners::AllocateResource
  class Listener
    def on_threat_created(e) = Job.perform_later(e[:threat].id)
    def on_resource_not_allocated(e) = Job.set(wait: 5.seconds).perform_later(e[:threat].id)
  end
end
