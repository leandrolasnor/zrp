REDIS = ConnectionPool.new(size: 4) do
  Redis::Namespace.new(
    'background-jobs',
    redis: Redis.new(
      host: ENV.fetch('REDIS_HOST', 'localhost'),
      port: ENV.fetch('REDIS_PORT', '6379'),
      db: 1
    )
  )
end

REDIS.with do
  Resque.redis = _1
end

# accessing data
# CACHE.with do |conn|
#   conn.get(<key>)
#   conn.set(<key>, <value>)
# end
