# frozen_string_literal: true

Resque::UniqueByArity.configure do |config|
  config.logger = nil
  config.log_level = :debug
  config.arity_for_uniqueness = 0 # | Defines the number of arguments that the perform method must have for the job's uniqueness to be determined
  config.unique_at_runtime = false
  config.unique_in_queue = false
  config.runtime_lock_timeout = 3 # seconds
  config.runtime_requeue_interval = 2 # seconds | Defines the interval (in seconds) between attempts to reenqueue the job if it is still blocked by another job in execution. This helps to prevent multiple jobs from being executed simultaneously.
  config.unique_at_runtime_key_base = 'r-uar'.freeze
  config.lock_after_execution_period = 0 # seconds | Specifies the period (in seconds) after the job execution during which the uniqueness lock will be maintained. This prevents the same job from being reexecuted immediately after completion.
  config.ttl = -1
  config.unique_in_queue_key_base = 'r-uiq'.freeze
end
