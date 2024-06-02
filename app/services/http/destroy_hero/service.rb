# frozen_string_literal: true

class Http::DestroyHero::Service < Http::ApplicationService
  option :serializer, type: Interface(:serializer_for), default: -> { Http::DestroyHero::Serializer }, reader: :private
  option :transaction, type: Interface(:call), default: -> { DestroyHero::Transaction.new }, reader: :private
  option :listener_destroy,
         type: Interface(:on_step_succeeded),
         default: -> { Http::DestroyHero::Listeners::Destroy },
         reader: :private
  option :widget_heroes_working_listener,
         type: Interface(:on_step_succeeded),
         default: -> { Http::DestroyHero::Listeners::Dashboard::Widgets::HeroesWorking::Listener },
         reader: :private

  Contract = Http::DestroyHero::Contract.new

  def call
    transaction.subscribe(destroy: listener_destroy)
    transaction.subscribe(destroy: widget_heroes_working_listener)
    transaction.call(params) do
      _1.failure :find do |f|
        [:not_found, f.message]
      end

      _1.failure :destroy do |f|
        [:unprocessable_entity, f.message]
      end

      _1.failure do |f|
        Rails.logger.error(f)
        [:internal_server_error]
      end

      _1.success do |destroyed|
        [:ok, destroyed, serializer]
      end
    end
  end
end
