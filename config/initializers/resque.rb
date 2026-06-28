# frozen_string_literal: true

Resque.logger = ActiveSupport::Logger.new(Rails.root.join('log', 'resque.log'), 5, 2 * 1024 * 1024)
Resque.logger.level = Logger::INFO

Resque.redis = Redis::Namespace.new(
  :resque,
  redis: Redis.new(
    host: ENV.fetch('REDIS_HOST', 'localhost'),
    port: ENV.fetch('REDIS_PORT', '6379'),
    db: 0,
    reconnect_attempts: 3,
    timeout: 5_000
  )
)
