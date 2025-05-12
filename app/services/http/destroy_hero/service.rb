# frozen_string_literal: true

module Http::DestroyHero
  class Service < Http::ApplicationService
    option :serializer, type: Types::Interface(:serializer_for), default: -> { Serializer }, reader: :private
    option :container, default: -> { Dry::Transaction(container: Delete::Hero::Container) }, reader: :private
    option :listener, type: Types::Interface(:on_step_succeeded), default: -> { Listener }, reader: :private
    option :transaction,
           type: Types::Interface(:call),
           default: -> { Delete::Transaction.include(container).new },
           reader: :private

    def call
      transaction.subscribe(destroy: listener)
      transaction.call(params) do
        it.success { |r| [:ok, r, serializer] }
        it.failure(:find) { |f| [:not_found, f.message] }
        it.failure(:destroy) { |f| [:unprocessable_entity, f.message] }
      end
    end
  end
end
