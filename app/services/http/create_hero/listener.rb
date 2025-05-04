# frozen_string_literal: true

module Http::CreateHero
  module Listener
    module_function

    def on_step_succeeded(_)
      Dashboard::Widgets::HeroesWorking::Job.perform_later
      Dashboard::Widgets::HeroesDistribution::Job.perform_later
    end
  end
end
