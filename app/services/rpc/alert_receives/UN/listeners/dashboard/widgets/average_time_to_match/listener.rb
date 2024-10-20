# frozen_string_literal: true

module Rpc::AlertReceives::UN::Listeners::Dashboard::Widgets::AverageTimeToMatch
  class Listener
    def on_resource_allocated(_)
      Resque.enqueue_at(1.minute.from_now, Job) if queue_empty?
    end

    private

    def queue_empty?
      Resque.size(:widget_average_time_to_match).zero?
    end
  end
end
