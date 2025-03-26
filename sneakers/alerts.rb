# frozen_string_literal: true

require_relative 'config'

class Processor
  include Sneakers::Worker

  from_queue :un

  def work(message)
    return requeue! if requeue?

    parsed = JSON.parse(message)
    occurrence = ::Rpc::Occurrence.new(parsed)
    ack! if client.(:Alert, occurrence).message.is_a?(::Rpc::Threat)
  rescue StandardError => error
    puts error.message
    puts error.backtrace
    requeue!
  end

  private

  def requeue?
    REDIS.with { _1.get('SNEAKERS_REQUEUE') == 'true' }
  end

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
