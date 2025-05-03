# frozen_string_literal: true

module DeallocateResource
  class Listener
    def on_resource_deallocated(_)
      Dashboard::Widgets::HeroesWorking::Job.perform_later
      Dashboard::Widgets::ThreatsDisabled::Job.perform_later
    end
  end
end
