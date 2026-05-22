require 'prometheus/middleware/collector'
require 'prometheus/middleware/exporter'

# O Collector coleta métricas padrão de requisições HTTP
Rails.application.middleware.use Prometheus::Middleware::Collector

# O Exporter expõe as métricas em um endpoint que o Prometheus irá "raspar"
Rails.application.middleware.use Prometheus::Middleware::Exporter
