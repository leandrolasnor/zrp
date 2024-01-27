# frozen_string_literal: true

class ApiController < ActionController::API
  rescue_from StandardError, with: :standard_error
  rescue_from ActionController::UnpermittedParameters, with: :unpermitted_parameters

  private

  def standard_error(e)
    Rails.logger.error(e)
    head :internal_server_error
  end

  def unpermitted_parameters(e)
    Rails.logger.error(e)
    render json: e.message, status: :unprocessable_entity
  end
end
