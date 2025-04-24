# frozen_string_literal: true

module Http::EditHero
  class Service < Http::ApplicationService
    option :serializer, type: Types::Interface(:serializer_for), default: -> { Serializer }, reader: :private
    option :container, reader: :private, default: -> do
      Dry::Transaction(container: Update::Hero::Container)
    end
    option :transaction, type: Types::Interface(:call), reader: :private, default: -> do
      Update::Transaction.include(container).new
    end
    option :widget_heroes_distribution_listener,
           type: Types::Interface(:on_step_succeeded),
           default: -> { Listeners::Dashboard::Widgets::HeroesDistribution::Listener },
           reader: :private

    def call
      transaction.subscribe(update: widget_heroes_distribution_listener)
      transaction.call(params) do
        it.failure :validate do |f|
          [:unprocessable_entity, f.errors.to_h]
        end

        it.failure :find do |f|
          [:unprocessable_entity, f.errors.to_h]
        end

        it.failure do |f|
          Rails.logger.error(f)
          [:internal_server_error]
        end

        it.success do |updated|
          [:ok, updated, serializer]
        end
      end
    end
  end
end
