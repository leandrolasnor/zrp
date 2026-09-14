# frozen_string_literal: true

class SSE::WidgetsController < SSE::ApplicationController
  def index
    redis.subscribe('sse:widgets') do |on|
      on.message do |_, message|
        data = JSON.parse(message)
        sse.write(data['payload'], event: data['type'])
      end
    end
  ensure
    redis&.close
    sse.close
  end
end
