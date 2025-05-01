# frozen_string_literal: true

module Http::DestroyHero
  class Service < Http::ApplicationService
    option :serializer, type: Types::Interface(:serializer_for), default: -> { Serializer }, reader: :private
    option :container, default: -> { Dry::Transaction(container: Delete::Hero::Container) }, reader: :private
    option :transaction, type: Types::Interface(:call), reader: :private, default: -> do
      Delete::Transaction.include(container).new
    end
    option :listener, type: Types::Interface(:on_step_succeeded), default: -> { Listener }, reader: :private

    def call
      transaction.subscribe(remove_from_index: listener)
      transaction.call(params) do
        it.failure :find do |f|
          [:not_found, f.message]
        end

        it.failure :destroy do |f|
          [:unprocessable_entity, f.message]
        end

        it.failure :remove_from_index do |f|
          [:unprocessable_entity, f.message]
        end

        it.failure do |f|
          Rails.logger.error(f)
          [:internal_server_error]
        end

        it.success do |destroyed|
          [:ok, destroyed, serializer]
        end
      end
    end
  end
end
