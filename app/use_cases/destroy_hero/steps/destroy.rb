# frozen_string_literal: true

class DestroyHero::Steps::Destroy
  include Dry::Monads[:result]

  def call(hero)
    hero.destroy!
  end
end
