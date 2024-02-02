# frozen_string_literal: true

class DestroyHero::Steps::Destroy
  include Dry::Monads[:result]

  def call(hero)
    raise StandardError.new(I18n.t(:hero_working, hero: hero.name)) if hero.working?

    hero.remove_from_index!
    hero.destroy!
  end
end
