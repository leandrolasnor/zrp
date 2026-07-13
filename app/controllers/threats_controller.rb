# frozen_string_literal: true

class ThreatsController < BaseController
  permit_params :historical, { permit: [:page, :per_page] }
  permit_params :set_insurgency, { permit: [:insurgency, { threat: {} }] }

  def historical
    status, content, serializer = Http::ThreatsHistory::Service.(params)
    render json: content, status: status, each_serializer: serializer
  end

  def set_insurgency
    Rails.cache.write('INSURGENCY_TIME', params[:insurgency].to_i * 1000, raw: true, expires_in: nil)
    head :ok
  end
end
