# frozen_string_literal: true

module Http::CreateHero
  module Listener
    module_function

    def on_step_succeeded(_)
      Dashboard::Widgets::Job.enqueue(:heroes_working)
      Dashboard::Widgets::Job.enqueue(:heroes_distribution)
    end
  end
end
