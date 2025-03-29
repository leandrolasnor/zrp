# frozen_string_literal: true

module Rpc::AlertReceives::UN::Listeners::Dashboard::Widgets::SuperHero
  class Listener
    def on_resource_allocated(_) = Resque.enqueue(Job)
  end
end
