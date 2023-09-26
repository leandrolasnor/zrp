# frozen_string_literal: true

opts = {
  amqp: 'amqp://rabbitmq',
  username: 'guest',
  password: 'guest',
  exchange: 'sneakers',
  exchange_type: :direct
}

Sneakers.configure(opts)
Sneakers.logger.level = Logger::INFO
