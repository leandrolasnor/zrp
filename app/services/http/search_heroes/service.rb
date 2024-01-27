# frozen_string_literal: true

class Http::SearchHeroes::Service < Http::ApplicationService
  option :monad, type: Interface(:call), default: -> { SearchHeroes::Monad.new }, reader: :private

  Contract = Http::SearchHeroes::Contract.new

  def call
    res = monad.call(**params)

    return [:ok, res.value!] if res.success?

    Rails.logger.error(res.exception)
    [:internal_server_error, res.exception.message]
  end
end
