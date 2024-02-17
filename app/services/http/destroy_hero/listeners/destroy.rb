# frozen_string_literal: true

module Http::DestroyHero::Listeners::Destroy
  module_function

  def on_step_succeeded(_event)
    Rails.cache.decrement(:hero_count, 1, expires_in: 10.seconds)
  end
end
