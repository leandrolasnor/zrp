# frozen_string_literal: true

class ListenersAmqp::Threats
  include Sneakers::Worker

  from_queue :threats

  def work(threat)
    parsed = JSON.parse(threat, symbolize_names: true)
    created = Ws::CreateThreat::Service.(parsed)
    ack! if created
  rescue StandardError => error
    Rails.logger.error(error)
  end
end
