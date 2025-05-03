REDIS = ConnectionPool.new(size: 4) do
  Redis.new(
    host: ENV.fetch('REDIS_HOST', 'localhost'),
    port: ENV.fetch('REDIS_PORT', '6379'),
    db: 0
  )
end

REDIS_JOBS = ConnectionPool.new(size: 4) do
  Redis::Namespace.new(
    'background-jobs',
    redis: Redis.new(
      host: ENV.fetch('REDIS_HOST', 'localhost'),
      port: ENV.fetch('REDIS_PORT', '6379'),
      db: 1
    )
  )
end

REDIS_JOBS.with { Resque.redis = it }
