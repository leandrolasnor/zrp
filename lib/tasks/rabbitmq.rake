# frozen_string_literal: true

namespace :rabbitmq do
  desc "Declara DLX exchange, fila de retry e bindings do sneakers"
  task setup: :environment do
    conn = Bunny.new(ENV.fetch('AMQP_SERVER'))
    conn.start
    channel = conn.create_channel

    channel.exchange('un.dlx', type: :direct, durable: true)

    channel.queue('un',
      durable: true,
      arguments: {
        'x-dead-letter-exchange' => 'un.dlx'
      })

    channel.queue('un.retry',
      durable: true,
      arguments: {
        'x-message-ttl' => 5000,
        'x-dead-letter-exchange' => '',
        'x-dead-letter-routing-key' => 'un'
      })

    channel.queue('un.retry').bind('un.dlx', routing_key: 'un')

    conn.close
  end
end
