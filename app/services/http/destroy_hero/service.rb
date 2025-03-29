# frozen_string_literal: true

class Http::DestroyHero::Service < Http::ApplicationService
  option :serializer, type: Interface(:serializer_for), default: -> { Http::DestroyHero::Serializer }, reader: :private
  option :transaction, type: Interface(:call), reader: :private, default: -> do
    CRUD::Delete::Transaction.include(Dry::Transaction(container: CRUD::Delete::Hero::Container)).new
  end
  option :widget_heroes_distribution_listener,
         type: Interface(:on_step_succeeded),
         default: -> { Http::DestroyHero::Listeners::Dashboard::Widgets::HeroesDistribution::Listener },
         reader: :private
  option :widget_heroes_working_listener,
         type: Interface(:on_step_succeeded),
         default: -> { Http::DestroyHero::Listeners::Dashboard::Widgets::HeroesWorking::Listener },
         reader: :private

  Contract = Http::DestroyHero::Contract.new

  def call
    transaction.subscribe(delete: widget_heroes_distribution_listener)
    transaction.subscribe(delete: widget_heroes_working_listener)
    transaction.call(params) do
      it.failure :find do |f|
        [:not_found, f.message]
      end

      it.failure :delete do |f|
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
