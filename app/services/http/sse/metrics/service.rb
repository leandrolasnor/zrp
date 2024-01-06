# frozen_string_literal: true

class Http::Sse::Metrics::Service < Http::Sse::Service
  option :monad, type: Interface(:call), default: -> { Metrics::Monad.new }, reader: :private

  def call
    monad.subscribe('metrics.fetched') do |event|
      payload = event[:payload].map do
        # format payload
      end
      sse.write({ type: 'METRICS_FETCHED', payload: payload })
    end
    res = monad.()

    Rails.logger.error(res.exception) if res.failure?
  end
end
