# frozen_string_literal: true

module Rpc::AlertReceives::UN::Listeners::Dashboard::Widgets::ThreatsDisabled
  class Listener
    def on_resource_deallocated(_)
      Resque.enqueue(Job)
    end

    def on_threat_created(_)
      Resque.enqueue(Job)
    end
  end
end
