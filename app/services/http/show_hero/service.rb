# frozen_string_literal: true

module Http::ShowHero
  class Service < Http::ApplicationService
    option :serializer, type: Types::Interface(:serializer_for), default: -> { Serializer }, reader: :private
    option :monad, type: Types::Interface(:call), default: -> { Read::Monad.new(:hero, params[:id]) }, reader: :private

    def call
      res = monad.call
      raise StandardError, res.exception if res.failure?

      [:ok, res.value!, serializer]
    end
  end
end
