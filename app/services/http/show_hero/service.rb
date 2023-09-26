# frozen_string_literal: true

class Http::ShowHero::Service < Http::Service
  option :serializer, type: Interface(:serializer_for), default: -> { Http::ShowHero::Serializer }, reader: :private
  option :monad, type: Interface(:call), default: -> { ShowHero::Monad.new }, reader: :private

  def call
    res = monad.call(params[:id])

    return [:ok, res.value!, serializer] if res.success?

    [:unprocessable_entity, res.exception.message]
  end
end
