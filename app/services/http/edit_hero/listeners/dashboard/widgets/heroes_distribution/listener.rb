# frozen_string_literal: true

module Http::EditHero::Listeners::Dashboard::Widgets::HeroesDistribution::Listener
  module_function

  Job = Http::EditHero::Listeners::Dashboard::Widgets::HeroesDistribution::Job
  def on_step_succeeded(_)
    Resque.enqueue(Job)
  end
end
