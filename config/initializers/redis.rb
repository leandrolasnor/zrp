# frozen_string_literal: true

REDIS = ConnectionPool.new(size: 4) do
  Redis.new(
    host: ENV.fetch('REDIS_HOST', 'localhost'),
    port: ENV.fetch('REDIS_PORT', '6379'),
    db: 0,
    reconnect_attempts: 3,
    timeout: 5_000
  )
end
