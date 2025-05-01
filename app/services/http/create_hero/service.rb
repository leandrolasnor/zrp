# frozen_string_literal: true

module Http::CreateHero
  class Service < Http::ApplicationService
    option :serializer, type: Types::Interface(:serializer_for), default: -> { Serializer }, reader: :private
    option :container, reader: :private, default: -> {
      Dry::Transaction(container: Create::Hero::Container)
    }
    option :transaction, type: Types::Interface(:call), reader: :private, default: -> {
      Create::Transaction.include(container).new
    }
    option :listener, type: Types::Interface(:on_step_succeeded), default: -> { Listener }, reader: :private

    def call
      transaction.subscribe(persist: listener)
      transaction.call(params) do
        it.failure :validate do |f|
          [:unprocessable_entity, f.errors.to_h]
        end

        it.failure do |f|
          Rails.logger.error(f)
          [:internal_server_error]
        end

        it.success do |created|
          [:created, created, serializer]
        end
      end
    end
  end
end
