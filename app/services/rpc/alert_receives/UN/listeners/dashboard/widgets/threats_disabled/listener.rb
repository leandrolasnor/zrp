# frozen_string_literal: true

module Rpc::AlertReceives::UN::Listeners::Dashboard::Widgets::ThreatsDisabled
  class Listener
    def on_resource_deallocated(_) = Job.perform
    def on_threat_created(_) = Job.perform
  end
end
