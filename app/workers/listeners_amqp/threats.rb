# frozen_string_literal: true

class ListenersAmqp::Threats
  include Sneakers::Worker

  from_queue :threats

  def work(threat)
    parsed = JSON.parse(threat, symbolize_names: true)
    res = Ws::CreateThreat::Service.(parsed)
    res.success? ? ack! : Rails.logger.error(res.exception)
  end
end
