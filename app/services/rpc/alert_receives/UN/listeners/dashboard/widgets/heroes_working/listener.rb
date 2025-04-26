# frozen_string_literal: true

module Rpc::AlertReceives::UN::Listeners::Dashboard::Widgets::HeroesWorking
  class Listener
    def on_resource_deallocated(_) = Resque.enqueue(Job)
    def on_resource_allocated(_) = Resque.enqueue(Job)
  end
end
