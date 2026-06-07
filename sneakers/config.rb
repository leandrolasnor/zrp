# frozen_string_literal: true

require 'dotenv'
Dotenv.load('./sneakers/.env')
require './config/environment'

opts = {
  amqp: ENV.fetch('AMQP_SERVER'),
  username: ENV.fetch('RABBITMQ_USER', 'guest'),
  password: ENV.fetch('RABBITMQ_PASS', 'guest'),
  vhost: ENV.fetch('RABBITMQ_VHOST', '/'),
  exchange: 'sneakers',
  exchange_type: :direct,
  ack: true,
  workers: 1,
  prefetch: 10,
  heartbeat: 5
}

Sneakers.configure(opts)
Sneakers.logger.level = Logger::INFO
