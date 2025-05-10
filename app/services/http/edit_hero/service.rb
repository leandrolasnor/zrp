# frozen_string_literal: true

module Http::EditHero
  class Service < Http::ApplicationService
    option :serializer, type: Types::Interface(:serializer_for), default: -> { Serializer }, reader: :private
    option :container, default: -> { Dry::Transaction(container: Update::Hero::Container) }, reader: :private
    option :listener, type: Types::Interface(:on_step_succeeded), default: -> { Listener }, reader: :private
    option :transaction,
           type: Types::Interface(:call),
           default: -> { Update::Transaction.include(container).new },
           reader: :private

    def call
      transaction.subscribe(update: listener)
      transaction.call(params) do
        it.success { |r| [:ok, r, serializer] }
        it.failure(:validate, :find) { |f| [:unprocessable_entity, f.errors] }
        it.failure { |f| raise StandardError, f }
      end
    end
  end
end
