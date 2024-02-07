REDIS = ConnectionPool.new(size: 2) do
  Redis::Namespace.new(
    Rails.env,
    redis: Redis.new(
      host: ENV.fetch('REDIS_HOST', 'localhost'),
      port: ENV.fetch('REDIS_PORT', '6379')
    )
  )
end

REDIS_DASHBOARD = ConnectionPool.new(size: 2) do
  Redis::Namespace.new(
    "dashboard-#{Rails.env}",
    redis: Redis.new(
      host: ENV.fetch('REDIS_HOST', 'localhost'),
      port: ENV.fetch('REDIS_PORT', '6379')
    )
  )
end

REDIS.with do
  Resque.redis = _1
end

# accessing data
# REDIS.with do |conn|
#   conn.get(<key>)
#   conn.set(<key>, <value>)
# end
