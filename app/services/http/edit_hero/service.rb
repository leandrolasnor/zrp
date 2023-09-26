# frozen_string_literal: true

class Http::EditHero::Service < Http::Service
  option :serializer, type: Interface(:serializer_for), default: -> { Http::EditHero::Serializer }, reader: :private
  option :transaction, type: Interface(:call), default: -> { EditHero::Transaction.new }, reader: :private

  def call
    transaction.call(params) do
      _1.failure :validate do |f|
        [:unprocessable_entity, f.errors.to_h]
      end

      _1.failure do |f|
        Rails.logger.error(f)
        [:internal_server_error]
      end

      _1.success do |updated|
        [:ok, updated, serializer]
      end
    end
  end
end
