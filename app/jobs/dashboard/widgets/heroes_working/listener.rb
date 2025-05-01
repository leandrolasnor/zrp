# frozen_string_literal: true

module Dashboard::Widgets::HeroesWorking
  class Listener
    def on_heroes_working(e) = Resque.enqueue(Sneakers::Requeue::Job, e[:heroes_working_metrics])
  end
end
