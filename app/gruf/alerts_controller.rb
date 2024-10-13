# frozen_string_literal: true

class AlertsController < Gruf::Controllers::Base
  bind ::Rpc::Alert::Service

  def handle
    threat = Grpc::CreateThreat::Service.(request: request)

    ::Rpc::Threat.new(
      name: threat.name,
      rank: threat.rank,
      status: threat.status,
      lat: threat.lat.to_f,
      lng: threat.lng.to_f
    )
  end
end
