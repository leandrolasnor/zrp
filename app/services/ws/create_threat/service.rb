# frozen_string_literal: true

class Ws::CreateThreat::Service < Ws::Service
  option :monad, type: Interface(:call), default: -> { CreateThreat::Monad.new }, reader: :private

  def call
    res = monad.call(params)

    raise res.exception if res.failure?

    res.value!
  end
end
