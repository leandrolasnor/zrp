# frozen_string_literal: true

module Http::Dashboard
  class Service < Http::ApplicationService
    option :monad, type: Types::Interface(:call), default: -> { Dashboard::Monad.new }, reader: :private

    def call
      res = monad.call
      raise StandardError, res.exception if res.failure?

      [:ok, res.value!]
    end
  end
end
