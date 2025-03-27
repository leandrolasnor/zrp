# frozen_string_literal: true

Resque::UniqueByArity.configure do |config|
  config.logger = nil
  config.log_level = :debug
  config.arity_for_uniqueness = 0 # defines the number of arguments that the perform method must have for the job's uniqueness to be determined
  config.unique_at_runtime = false
  config.unique_in_queue = false
  config.runtime_lock_timeout = 60 # seconds
  config.runtime_requeue_interval = 2 # seconds
  config.unique_at_runtime_key_base = 'r-uar'.freeze
  config.lock_after_execution_period = 0 # seconds
  config.ttl = -1
  config.unique_in_queue_key_base = 'r-uiq'.freeze
end
