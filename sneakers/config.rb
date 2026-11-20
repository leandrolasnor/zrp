# frozen_string_literal: true

require 'dotenv'
Dotenv.load('./sneakers/.env')
require './config/environment'

log_path = Rails.root.join('log', 'sneakers.log')
FileUtils.mkdir_p(log_path.dirname)

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
  heartbeat: 5,
  log: log_path.to_s
}

Sneakers.configure(opts)
Sneakers.logger.level = Logger::INFO
