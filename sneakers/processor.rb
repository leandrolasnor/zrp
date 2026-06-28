# frozen_string_literal: true

require 'digest'
require_relative 'config'

class Processor
  include Sneakers::Worker

  MAX_RETRIES = 5
  RETRY_TTL = 3600

  from_queue :un,
             arguments: {
               'x-dead-letter-exchange' => 'un.dlx'
             }

  def work(message)
    return reject! if requeue?

    occurrence = ::Rpc::Occurrence.new(JSON.parse(message))
    if ihero.(:Alert, occurrence).message.is_a?(::Rpc::Threat)
      clear_retry_count(message)
      ack!
    else
      handle_retry(message)
    end
  rescue JSON::ParserError => error
    Sneakers.logger.error "Invalid JSON: #{error.message}"
    dead!(message, routing_key: 'parser.error')
  rescue StandardError => error
    Sneakers.logger.error "#{error.message}\n#{error.backtrace&.first(5)&.join("\n")}"
    handle_retry(message)
  end

  private

  def dead!(message, routing_key: 'dead')
    dead_exchange.publish(message, routing_key: routing_key, persistent: true)
    Sneakers.logger.info "Message dead-lettered to un.#{routing_key.tr('.', '_')}"
    ack!
  rescue StandardError => error
    Sneakers.logger.error "Failed to dead-letter message: #{error.message}"
    ack!
  end

  def dead_exchange
    @dead_exchange ||= channel.exchange('un.dlx', type: :direct, durable: true)
  end

  def handle_retry(message)
    if retry_exhausted?(message)
      Sneakers.logger.error "Max retries reached, discarding message to dead queue"
      dead!(message)
    else
      increment_retry(message)
      reject!
    end
  end

  def increment_retry(message)
    REDIS.with do |r|
      r.incr(retry_key(message))
      r.expire(retry_key(message), RETRY_TTL)
    end
  end

  def requeue? = REDIS.with { it.get('SNEAKERS_REQUEUE') == 'true' }
  def retry_exhausted?(message) = REDIS.with { it.get(retry_key(message)) }.to_i >= MAX_RETRIES
  def clear_retry_count(message) = REDIS.with { it.del(retry_key(message)) }
  def retry_key(message) = "sneakers:retry:#{Digest::SHA256.hexdigest(message)}"

  def ihero
    @ihero ||=
      ::Gruf::Client.new(
        service: ::Rpc::UN,
        options: {
          hostname: ENV.fetch('GRUF_SERVER', nil),
          password: ENV.fetch('GRUF_AUTH_TOKEN', nil)
        },
        client_options: {
          timeout: 5
        }
      )
  end
end
