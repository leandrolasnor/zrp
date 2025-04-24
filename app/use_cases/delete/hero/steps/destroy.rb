# frozen_string_literal: true

class Delete::Hero::Steps::Destroy
  def call(hero)
    raise ActiveRecord::RecordNotDestroyed.new(I18n.t(:hero_working, hero: hero.name)) if hero.working?

    hero.destroy!
  end
end
