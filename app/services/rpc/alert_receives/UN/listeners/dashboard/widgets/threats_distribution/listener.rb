# frozen_string_literal: true

module Rpc::AlertReceives::UN::Listeners::Dashboard::Widgets::ThreatsDistribution
  class Listener
    def on_threat_created(_)
      Resque.enqueue(Job)
    end
  end
end
