# frozen_string_literal: true

require_relative 'config'

$redis = Redis.new(host: "redis", port: 6379, db: 1) # rubocop:disable Style/GlobalVars

class Processor
  include Sneakers::Worker

  from_queue :un

  def work(message)
    parsed = JSON.parse(message)
    occurrence = ::Rpc::Occurrence.new(parsed)
    ack! if client.(:Alert, occurrence).message.is_a?(::Rpc::Threat)
  rescue StandardError => error
    puts error.message
    puts error.backtrace
  end

  private

  def client
    @client ||=
      ::Gruf::Client.new(
        service: ::Rpc::UN,
        options: {
          hostname: ENV.fetch('GRUF_SERVER', nil),
          password: ENV.fetch('GRUF_AUTH_TOKEN', nil)
        }
      )
  end
end
