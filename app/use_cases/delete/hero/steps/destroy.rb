# frozen_string_literal: true

class Delete::Hero::Steps::Destroy
  def call(hero)
    raise ActiveRecord::RecordNotDestroyed.new(I18n.t(:cannot_destroy_hero)) if hero.blank?

    hero.destroy!
  end
end
