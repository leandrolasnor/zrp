# frozen_string_literal: true

module Http::CreateHero::Listeners::Create
  module_function

  def on_step_succeeded(_event)
    Rails.cache.increment(:hero_count, 1, expires_in: 10.seconds)
  end
end
