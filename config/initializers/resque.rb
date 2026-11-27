# frozen_string_literal: true

if (redis_config = Rails.application.config_for(:redis))
  Resque.logger = ActiveSupport::Logger.new($stdout)
  Resque.logger.level = Logger::DEBUG

  Resque.redis = Redis::Namespace.new(
    :jobs,
    redis: Redis.new(**redis_config.symbolize_keys)
  )
end
