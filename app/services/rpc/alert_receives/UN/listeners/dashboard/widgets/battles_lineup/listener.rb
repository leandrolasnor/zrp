# frozen_string_literal: true

module Rpc::AlertReceives::UN::Listeners::Dashboard::Widgets::BattlesLineup
  class Listener
    def on_resource_allocated(_)
      Resque.enqueue_at(3.seconds.from_now, Job) if queue_empty?
    end

    private

    def queue_empty?
      Resque.size(:widget_battles_lineup).zero?
    end
  end
end
