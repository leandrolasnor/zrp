# frozen_string_literal: true

module Http::CreateHero::Listeners::Dashboard::Widgets::HeroesWorking::Listener
  module_function

  Job = Http::CreateHero::Listeners::Dashboard::Widgets::HeroesWorking::Job
  def on_step_succeeded(_) = Resque.enqueue(Job)
end
