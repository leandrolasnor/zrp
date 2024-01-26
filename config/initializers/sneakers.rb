# frozen_string_literal: true

opts = {
  amqp: ENV.fetch('AMQP_SERVER'),
  username: 'guest',
  password: 'guest',
  exchange: 'sneakers',
  exchange_type: :direct,
  ack: false,
  workers: 1
}

Sneakers.configure(opts)
Sneakers.logger.level = Logger::INFO
