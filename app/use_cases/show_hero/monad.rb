# frozen_string_literal: true

class ShowHero::Monad
  include Dry::Monads[:try]
  include Dry.Types()
  extend  Dry::Initializer

  option :hero, type: Interface(:find), default: -> { ShowHero::Model::Hero }, reader: :private

  def call(id)
    Try(ActiveRecord::RecordNotFound) { hero.find(id) }
  end
end
