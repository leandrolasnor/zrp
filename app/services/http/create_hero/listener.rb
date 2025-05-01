# frozen_string_literal: true

module Http::CreateHero
  module Listener
    module_function

    def on_step_succeeded(_)
      Resque.enqueue(Dashboard::Widgets::HeroesWorking::Job)
      Resque.enqueue(Dashboard::Widgets::HeroesDistribution::Job)
    end
  end
end
