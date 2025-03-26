# frozen_string_literal: true

require 'dotenv'
Dotenv.load('./sneakers/.env')
require './config/environment'

opts = {
  amqp: ENV.fetch('AMQP_SERVER', nil),
  username: 'guest',
  password: 'guest',
  exchange: 'sneakers',
  exchange_type: :direct,
  ack: false,
  workers: 1
}

Sneakers.configure(opts)
Sneakers.logger.level = Logger::INFO
