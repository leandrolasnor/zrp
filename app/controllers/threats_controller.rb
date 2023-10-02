# frozen_string_literal: true

class ThreatsController < BaseController
  def historical
    status, content, serializer = Http::ThreatsHistory::Service.(threat_history_params)
    render json: content, status: status, each_serializer: serializer
  end

  private

  def threat_history_params
    params.permit(:page, :per_page)
  end
end
