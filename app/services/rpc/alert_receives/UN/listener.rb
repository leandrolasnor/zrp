# frozen_string_literal: true

module Rpc::AlertReceives::UN
  class Listener
    def on_threat_created(e)
      Resque.enqueue(AllocateResource::Job, e[:threat].id)
      Resque.enqueue(Dashboard::Widgets::ThreatsDisabled::Job)
      Resque.enqueue(Dashboard::Widgets::ThreatsDistribution::Job)
    end
  end
end
