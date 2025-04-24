# frozen_string_literal: true

class Http::DestroyHero::Service < Http::ApplicationService
  option :serializer, type: Types::Interface(:serializer_for), default: -> { Http::DestroyHero::Serializer }, reader: :private
  option :container, default: -> { Dry::Transaction(container: Delete::Hero::Container) }, reader: :private
  option :transaction, type: Types::Interface(:call), reader: :private, default: -> do
    Delete::Transaction.include(container).new
  end
  option :widget_heroes_distribution_listener,
         type: Types::Interface(:on_step_succeeded),
         default: -> { Http::DestroyHero::Listeners::Dashboard::Widgets::HeroesDistribution::Listener },
         reader: :private
  option :widget_heroes_working_listener,
         type: Types::Interface(:on_step_succeeded),
         default: -> { Http::DestroyHero::Listeners::Dashboard::Widgets::HeroesWorking::Listener },
         reader: :private

  Contract = Http::DestroyHero::Contract.new

  def call
    transaction.subscribe(remove_from_index: widget_heroes_distribution_listener)
    transaction.subscribe(remove_from_index: widget_heroes_working_listener)
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
