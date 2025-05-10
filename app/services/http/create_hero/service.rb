# frozen_string_literal: true

module Http::CreateHero
  class Service < Http::ApplicationService
    option :serializer, type: Types::Interface(:serializer_for), default: -> { Serializer }, reader: :private
    option :container, reader: :private, default: -> { Dry::Transaction(container: Create::Hero::Container) }
    option :listener, type: Types::Interface(:on_step_succeeded), default: -> { Listener }, reader: :private
    option :transaction,
           type: Types::Interface(:call),
           reader: :private,
           default: -> { Create::Transaction.include(container).new }

    def call
      transaction.subscribe(persist: listener)
      transaction.call(params) do
        it.success { |r| [:created, r, serializer] }
        it.failure(:validate) { |f| [:unprocessable_entity, f.errors] }
        it.failure { |f| raise StandardError, f }
      end
    end
  end
end
