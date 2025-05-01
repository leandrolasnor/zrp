# frozen_string_literal: true

module Http::ThreatsHistory
  class Service < Http::ApplicationService
    option :serializer, type: Types::Interface(:serializer_for), default: -> { Serializer }, reader: :private
    option :monad, type: Types::Interface(:call), default: -> { ThreatsHistory::Monad.new }, reader: :private

    def call
      res = monad.call(**params.symbolize_keys)

      return [:ok, res.value!, serializer] if res.success?

      Rails.logger.error(res.exception)
      [:internal_server_error, res.exception.message]
    end
  end
end
