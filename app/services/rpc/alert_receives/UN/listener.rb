# frozen_string_literal: true

module Rpc::AlertReceives::UN
  class Listener
    def on_threat_created(e)
      AllocateResource::Job.perform_later(e[:threat].id)
      Dashboard::Widgets::ThreatsDisabled::Job.perform_later
      Dashboard::Widgets::ThreatsDistribution::Job.perform_later
    end
  end
end
