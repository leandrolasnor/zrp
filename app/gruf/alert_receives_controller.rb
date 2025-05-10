# frozen_string_literal: true

class AlertReceivesController < Gruf::Controllers::Base
  bind ::Rpc::UN::Service

  def alert
    Rpc::AlertReceives::UN::Service.(request.message)
  end
end
