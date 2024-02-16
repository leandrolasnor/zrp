# frozen_string_literal: true

class Ws::CreateThreat::Service < Ws::ApplicationService
  option :monad, type: Interface(:call), default: -> { CreateThreat::Monad.new }, reader: :private
  option :worker,
         type: Interface(:perform),
         default: -> { Ws::CreateThreat::AllocateResource::Job }, reader: :private
  option :queueer, type: Instance(Proc), default: -> { proc { Resque.enqueue(worker, _1) } }, reader: :private

  def call
    monad.subscribe('threat.created') do
      queueer.(_1[:threat].id)
    end

    monad.call(params)
  end
end
