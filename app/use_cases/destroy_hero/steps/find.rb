# frozen_string_literal: true

class DestroyHero::Steps::Find
  include Dry::Monads[:result]
  include Dry.Types()
  extend  Dry::Initializer

  option :hero, type: Interface(:find), default: -> { DestroyHero::Model::Hero }, reader: :private

  def call(params)
    hero.lock.find(params[:id])
  end
end
