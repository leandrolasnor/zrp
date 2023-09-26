# frozen_string_literal: true

class SaveThreatEvent
  include Sneakers::Worker
  from_queue :threats

  def work(event)
    pp JSON.parse(event, symbolize_names: true)
    ack!
  end
end
