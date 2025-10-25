# frozen_string_literal: true

module RemoveFromIndex
  class Monad
    include Dry::Monads[:try]
    extend Dry::Initializer

    option :id, type: Types::Coercible::Integer, reader: :private
    option :model, type: Types::Instance(ActiveRecord::Base), reader: :private

    def call = Try(StandardError) { model.index.delete_document(id) }
  end
end
