# frozen_string_literal: true

Resque::UniqueByArity.configure do |config|
  config.logger = nil # config.log_level = :debug
  config.arity_for_uniqueness = 0 # | Quantos argumentos olhar pra decidir se o job é único
  config.unique_at_runtime = false # Impede que dois jobs iguais rodem ao mesmo tempo
  config.unique_in_queue = false # Impede que dois jobs iguais sejam enfileirados
  config.runtime_lock_timeout = 5 # seconds | Duração máxima do lock enquanto o job roda
  config.runtime_requeue_interval = 5 # seconds | Tempo entre tentativas se o job estiver bloqueado
  config.lock_after_execution_period = 5 # seconds | Quanto tempo manter o lock depois que terminar
  config.unique_at_runtime_key_base = 'r-uar'.freeze
  config.unique_in_queue_key_base = 'r-uiq'.freeze
  config.ttl = -1
end
