# frozen_string_literal: true

class Http::CreateHero::Service < Http::ApplicationService
  option :serializer, type: Interface(:serializer_for), default: -> { Http::CreateHero::Serializer }, reader: :private
  option :transaction, type: Interface(:call), default: -> { CreateHero::Transaction.new }, reader: :private
  option :widget_heroes_working_listener,
         type: Interface(:on_step_succeeded),
         default: -> { Http::CreateHero::Listeners::Dashboard::Widgets::HeroesWorking::Listener },
         reader: :private

  def call
    transaction.subscribe(create: widget_heroes_working_listener)
    transaction.call(params) do
      _1.failure :validate do |f|
        [:unprocessable_entity, f.errors.to_h]
      end

      _1.failure do |f|
        Rails.logger.error(f)
        [:internal_server_error]
      end

      _1.success do |created|
        [:created, created, serializer]
      end
    end
  end
end
