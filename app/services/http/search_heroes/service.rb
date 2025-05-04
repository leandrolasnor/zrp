# frozen_string_literal: true

module Http::SearchHeroes
  class Service < Http::ApplicationService
    option :monad, type: Types::Interface(:call), default: -> { SearchHeroes::Monad.new(**params) }, reader: :private

    def call
      res = monad.call

      return [:ok, res.value!] if res.success?

      Rails.logger.error(res.exception)
      [:internal_server_error, res.exception.message]
    end
  end
end
