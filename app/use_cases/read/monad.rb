# frozen_string_literal: true

module Read
  class Monad
    include Dry::Monads[:try]
    extend  Dry::Initializer

    param :entity, type: Types::Coercible::String, reader: :private
    param :id, type: Types::Coercible::Integer, reader: :private
    option :model, type: Types::Interface(:find), default: -> {
      "read/#{entity}/model/#{entity}".camelize.safe_constantize
    }, reader: :private

    def call = Try(ActiveRecord::RecordNotFound) { model.find(id) }
  end
end
