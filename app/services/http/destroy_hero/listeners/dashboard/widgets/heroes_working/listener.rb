# frozen_string_literal: true

module Http::DestroyHero::Listeners::Dashboard::Widgets::HeroesWorking::Listener
  module_function

  Job = Http::DestroyHero::Listeners::Dashboard::Widgets::HeroesWorking::Job
  def on_step_succeeded(_)
    Resque.enqueue_at(3.seconds.from_now, Job) if queue_empty?
  end

  def queue_empty?
    Resque.size(:widget_heroes_working).zero?
  end
end
