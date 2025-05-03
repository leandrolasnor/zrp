# frozen_string_literal: true

module Dashboard::Widgets::HeroesWorking
  class Listener
    def on_heroes_working(e) = Sneakers::Requeue::Job.perform_later(e[:heroes_working_metrics])
  end
end
