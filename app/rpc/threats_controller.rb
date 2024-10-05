# frozen_string_literal: true

class ThreatsController < Gruf::Controllers::Base
  bind ::Rpc::Threats::Service

  def create_threat
    res = CreateThreat::Monad.find(request)

    raise res.exception if res.failure?

    
    Thread.new(
      {

      }
    )
  rescue StandardError => error
    set_debug_info(error.message, error.backtrace[0..4])
    fail!(:internal, :internal, "ERROR: #{error.message}")
  end
end
