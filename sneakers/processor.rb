# frozen_string_literal: true

require 'digest'
require_relative 'config'
require_relative 'readiness'

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
    # Só opera quando RabbitMQ e gRPC estão prontos. A mensagem volta para
    # un.retry (5s) sem incrementar o contador de tentativas de domínio.
    return not_ready! unless Readiness.ready?(self)

    process_alert(message)
  rescue JSON::ParserError => error
    Sneakers.logger.error "Invalid JSON: #{error.message}"
    dead!(message, routing_key: 'parser.error')
  rescue *Readiness::GRPC_INFRASTRUCTURE_ERRORS => error
    # gRPC fora não é erro da mensagem: não conta tentativa nem vai para dead.
    Sneakers.logger.error "gRPC unavailable, requeueing: #{error.message}"
    reject!
  rescue StandardError => error
    Sneakers.logger.error "#{error.message}\n#{error.backtrace&.first(5)&.join("\n")}"
    handle_retry(message)
  end

  private

  def process_alert(message)
    occurrence = ::Rpc::Occurrence.new(JSON.parse(message))
    if ihero.(:Alert, occurrence).message.is_a?(::Rpc::Threat)
      clear_retry_count(message)
      ack!
    else
      handle_retry(message)
    end
  end

  def not_ready!
    Sneakers.logger.warn 'Waiting for rabbitmq and grpc before processing messages'
    reject!
  end

  def dead!(message, routing_key: 'dead')
    dead_exchange.publish(message, routing_key: routing_key, persistent: true)
    Sneakers.logger.info "Message dead-lettered to un.#{routing_key.tr('.', '_')}"
    ack!
  rescue StandardError => error
    Sneakers.logger.error "Failed to dead-letter message: #{error.message}"
    reject!
  end

  def dead_exchange
    @dead_exchange ||= queue.channel.exchange('un.dlx', type: :direct, durable: true)
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
    Rails.cache.increment(retry_key(message), 1, expires_in: RETRY_TTL)
  end

  def requeue? = Rails.cache.read('SNEAKERS_REQUEUE') == true
  def retry_exhausted?(message) = Rails.cache.read(retry_key(message)).to_i >= MAX_RETRIES
  def clear_retry_count(message) = Rails.cache.delete(retry_key(message))
  def retry_key(message) = "sneakers:retry:#{Digest::SHA256.hexdigest(message)}"

  def ihero
    @ihero ||=
      ::Gruf::Client.new(
        service: ::Rpc::UN,
        options: {
          hostname: ENV.fetch('GRUF_SERVER'),
          password: ENV.fetch('GRUF_AUTH_TOKEN')
        },
        client_options: {
          timeout: 10
        }
      )
  end
end
