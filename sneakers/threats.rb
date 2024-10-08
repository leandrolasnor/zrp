# frozen_string_literal: true

require 'initializer'

$redis = Redis.new(host: "redis", port: 6379, db: 1)

class Processor
  include Sneakers::Worker

  from_queue :threats

  def work(threat)
    # params = Threat.new(JSON.parse(threat, symbolize_names: true))
    # ack! if stub.create_threat(params).ok?
    puts threat
  end

  private

  def stub
    Threats::Stub.new('localhost:50057', :this_channel_is_insecure)
  end
end
