# frozen_string_literal: true

module Rpc::AlertReceives::UN::Listeners::Dashboard::Widgets::ThreatsDistribution
  class Listener
    def on_threat_created(_)
      Resque.enqueue_at(3.seconds.from_now, Job) if queue_empty?
    end

    private

    def queue_empty?
      Resque.size(:widget_threats_disabled).zero?
    end
  end
end
