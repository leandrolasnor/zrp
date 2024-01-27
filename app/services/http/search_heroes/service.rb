# frozen_string_literal: true

class Http::SearchHeroes::Service < Http::ApplicationService
  option :monad, type: Interface(:call), default: -> { SearchHeroes::Monad.new }, reader: :private

  Contract = Http::SearchHeroes::Contract.new

  def call
    res = monad.call(**params.symbolize_keys)

    return [[:status, :ok], [:content, res.value!]].to_h if res.success?

    Rails.logger.error(res.exception)
    [[:status, :internal_server_error], [:content, res.exception.message]].to_h
  end
end
