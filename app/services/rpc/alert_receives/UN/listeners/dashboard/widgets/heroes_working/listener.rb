# frozen_string_literal: true

module Rpc::AlertReceives::UN::Listeners::Dashboard::Widgets::HeroesWorking
  class Listener
    def on_resource_deallocated(_) = Job.perform
    def on_resource_allocated(_) = Job.perform
  end
end
