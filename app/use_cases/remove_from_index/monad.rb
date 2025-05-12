# frozen_string_literal: true

module RemoveFromIndex
  class Monad
    include Dry::Monads[:try]
    extend Dry::Initializer

    option :id, type: Types::Coercible::Integer, reader: :private
    option :index, type: Types::Interface(:delete_document), reader: :private

    def call = Try(StandardError) { index.delete_document(id) }
  end
end
