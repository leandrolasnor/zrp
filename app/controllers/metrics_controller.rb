# frozen_string_literal: true

class MetricsController < BaseController
  def dashboard
    Http::Sse::Dashboard::Service.(response: response)
  end
end
