# frozen_string_literal: true

class DestroyHero::Steps::Destroy
  include Dry::Monads[:result]
  include Dry::Events::Publisher[:hero_destroyed]

  register_event 'hero.destroyed'

  def call(hero)
    raise StandardError.new(I18n.t(:hero_working, hero: hero.name)) if hero.working?

    hero.remove_from_index!
    destroyed = hero.destroy!
    publish('hero.destroyed', hero: destroyed)
    destroyed
  end
end
