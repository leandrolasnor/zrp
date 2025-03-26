# frozen_string_literal: true

class ThreatsController < BaseController
  def historical
    status, content, serializer = Http::ThreatsHistory::Service.(threat_history_params)
    render json: content, status: status, each_serializer: serializer
  end

  def set_insurgency
    REDIS.with { _1.set('INSURGENCY_TIME', set_insurgency_params[:insurgency].to_i * 1000) }
    head :ok
  end

  private

  def threat_history_params
    params.permit(:page, :per_page)
  end

  def set_insurgency_params
    params.permit(:insurgency, threat: {})
  end
end
