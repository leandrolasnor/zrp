# frozen_string_literal: true

module DeallocateResource
  class Listener
    def on_resource_deallocated(_)
      Resque.enqueue(Dashboard::Widgets::HeroesWorking::Job)
      Resque.enqueue(Dashboard::Widgets::ThreatsDisabled::Job)
    end
  end
end
