# frozen_string_literal: true

module Http::DestroyHero
  module Listener
    module_function

    def on_step_succeeded(_)
      Dashboard::Widgets::HeroesWorking::Job.perform_later
      Resque.enqueue(Dashboard::Widgets::HeroesDistribution::Job)
    end
  end
end
