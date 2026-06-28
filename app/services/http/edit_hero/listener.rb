# frozen_string_literal: true

module Http::EditHero::Listener
  module_function

  def on_step_succeeded(_) = Dashboard::Widgets::Job.enqueue(:heroes_distribution)
end
