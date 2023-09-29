# frozen_string_literal: true

class Ws::CreateThreat::Service < Ws::Service
  option :monad, type: Interface(:call), default: -> { CreateThreat::Monad.new }, reader: :private
  option :worker,
         type: Interface(:perform),
         default: -> { Ws::CreateThreat::AllocateResource::Job }, reader: :private
  option :queueer, type: Instance(Proc), default: -> { proc { Resque.enqueue(worker, _1) } }, reader: :private

  def call
    monad.subscribe('threat.created') do
      queueer.(_1[:threat].id)
    end

    res = monad.call(params)
    return res.value! if res.success?

    Rails.logger.error(res.exception)
    false
  end
end
