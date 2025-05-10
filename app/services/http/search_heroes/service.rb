# frozen_string_literal: true

module Http::SearchHeroes
  class Service < Http::ApplicationService
    option :monad, type: Types::Interface(:call), default: -> { SearchHeroes::Monad.new(**params) }, reader: :private

    def call
      res = monad.call
      raise StandardError, res.exception if res.failure?

      [:ok, res.value!]
    end
  end
end
