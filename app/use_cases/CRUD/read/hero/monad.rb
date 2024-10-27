# frozen_string_literal: true

module CRUD::Read::Hero
  class Monad
    include Dry::Monads[:try]
    include Dry.Types()
    extend  Dry::Initializer

    option :hero, type: Interface(:find), default: -> { Model::Hero }, reader: :private

    def call(id)
      Try(ActiveRecord::RecordNotFound) { hero.find(id) }
    end
  end
end
