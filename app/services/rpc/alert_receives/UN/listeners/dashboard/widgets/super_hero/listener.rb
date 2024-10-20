# frozen_string_literal: true

module Rpc::AlertReceives::UN::Listeners::Dashboard::Widgets::SuperHero
  class Listener
    def on_resource_allocated(_)
      Resque.enqueue_at(1.minute.from_now, Job) if queue_empty?
    end

    private

    def queue_empty?
      Resque.size(:widget_super_hero).zero?
    end
  end
end
