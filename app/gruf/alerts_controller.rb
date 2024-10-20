# frozen_string_literal: true

class AlertsController < Gruf::Controllers::Base
  bind ::Rpc::Alert::Service

  def handle
    Rpc::CreateThreat::Service.(request.message.to_h)
  end
end
