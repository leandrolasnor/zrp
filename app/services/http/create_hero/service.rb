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
    option :widget_heroes_working_listener,
           type: Types::Interface(:on_step_succeeded),
           default: -> { Listeners::Dashboard::Widgets::HeroesWorking::Listener },
           reader: :private
    option :widget_heroes_distribution_listener,
           type: Types::Interface(:on_step_succeeded),
           default: -> { Listeners::Dashboard::Widgets::HeroesDistribution::Listener },
           reader: :private

    def call
      transaction.subscribe(persist: widget_heroes_working_listener)
      transaction.subscribe(persist: widget_heroes_distribution_listener)
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
