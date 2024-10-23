# frozen_string_literal: true

module Rpc::AlertReceives::UN::Listeners::Dashboard::Widgets::HeroesWorking
  class Listener
    def on_resource_deallocated(_)
      Resque.enqueue_at(3.seconds.from_now, Job) if queue_empty?
    end

    def on_resource_allocated(_)
      Resque.enqueue_at(3.seconds.from_now, Job) if queue_empty?
    end

    private

    def queue_empty?
      Resque.size(:widget_heroes_working).zero?
    end
  end
end