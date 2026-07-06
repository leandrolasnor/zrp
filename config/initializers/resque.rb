# frozen_string_literal: true

if (redis_config = Rails.application.config_for(:redis))
  Resque.logger = ActiveSupport::Logger.new(Rails.root.join('log', 'resque.log'), 5, 2 * 1024 * 1024)
  Resque.logger.level = Logger::DEBUG

  Resque.redis = Redis::Namespace.new(
    :jobs,
    redis: Redis.new(**redis_config.symbolize_keys)
  )
end
