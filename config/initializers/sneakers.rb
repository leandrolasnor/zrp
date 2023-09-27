# frozen_string_literal: true

opts = {
  amqp: 'amqp://rabbitmq',
  username: 'guest',
  password: 'guest',
  exchange: 'sneakers',
  exchange_type: :direct,
  ack: false,
  workers: 1
}

Sneakers.configure(opts)
Sneakers.logger.level = Logger::INFO
