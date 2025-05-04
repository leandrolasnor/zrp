# frozen_string_literal: true

class Http::Sse::Dashboard::Service < Http::Sse::ApplicationService
  option :monad, type: Types::Interface(:call), default: -> { Dashboard::Monad.new }, reader: :private

  def call
    AppEvents.subscribe('metrics.fetched') do |event|
      sse.write(type: 'METRICS_FETCHED', payload: event.payload)
    end
    res = monad.()

    return Rails.logger.error(res.exception) if res.failure?

    res.value!
  end
end
