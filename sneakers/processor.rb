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

    parsed = JSON.parse(message)
    occurrence = ::Rpc::Occurrence.new(parsed)
    result = client.(:Alert, occurrence)

    if result.message.is_a?(::Rpc::Threat)
      clear_retry_count(message)
      ack!
    else
      requeue!
    end
  rescue JSON::ParserError => error
    Sneakers.logger.error "Invalid JSON: #{error.message}"
    reject!
  rescue StandardError => error
    Sneakers.logger.error "#{error.message}\n#{error.backtrace&.first(5)&.join("\n")}"

    if retry_exhausted?(message)
      Sneakers.logger.error "Max retries reached, discarding message"
      reject!
    else
      increment_retry(message)
      requeue!
    end
  end

  private

  def requeue? = REDIS.with { it.get('SNEAKERS_REQUEUE') == 'true' }

  def retry_exhausted?(message)
    REDIS.with { it.get(retry_key(message)) }.to_i >= MAX_RETRIES
  end

  def increment_retry(message)
    REDIS.with do |r|
      r.incr(retry_key(message))
      r.expire(retry_key(message), RETRY_TTL)
    end
  end

  def clear_retry_count(message)
    REDIS.with { it.del(retry_key(message)) }
  end

  def retry_key(message)
    "sneakers:retry:#{Digest::SHA256.hexdigest(message)}"
  end

  def client
    @client ||=
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
