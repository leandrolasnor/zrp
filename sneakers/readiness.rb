# frozen_string_literal: true

require 'socket'

# O Processor só deve processar mensagens quando os dois serviços dos quais
# depende estão disponíveis. O RabbitMQ é gerenciado pelo próprio Sneakers
# (reconexão automática); aqui apenas confirmamos que o canal consumer está
# aberto. O gRPC é verificado por um TCP connect curto, sem dependender de
# uma chamada de negócio.
module Readiness
  module_function

  # Erros que indicam problema de infraestrutura, não de conteúdo da mensagem.
  # Essas mensagens não devem contar como tentativa de domínio nem ir para dead.
  GRPC_INFRASTRUCTURE_ERRORS = [
    Gruf::Client::Errors::Unavailable,
    Gruf::Client::Errors::DeadlineExceeded,
    Gruf::Client::Errors::Cancelled,
    GRPC::Unavailable,
    GRPC::DeadlineExceeded,
    SocketError,
    Errno::ECONNREFUSED,
    Errno::EHOSTUNREACH,
    Errno::ENETUNREACH,
    Errno::ETIMEDOUT
  ].freeze

  def amqp_ready?(worker)
    !!worker.queue.channel&.open?
  rescue StandardError
    false
  end

  def grpc_ready?(hostname = ENV.fetch('GRUF_SERVER'), connect_timeout: 1)
    host, port = hostname.to_s.split(':')
    return false if host.blank? || port.nil?

    Socket.tcp(host, port.to_i, connect_timeout: connect_timeout) { true }
  rescue StandardError
    false
  end

  def ready?(worker, hostname = ENV.fetch('GRUF_SERVER'))
    amqp_ready?(worker) && grpc_ready?(hostname)
  end

  def infrastructure_error?(error)
    GRPC_INFRASTRUCTURE_ERRORS.any? { |klass| error.is_a?(klass) }
  end
end
