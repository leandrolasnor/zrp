# frozen_string_literal: true

class ApplicationController < ApiController
  rescue_from ActiveRecord::RecordNotFound, with: :not_found

  private

  def not_found
    render head: :not_found
  end
end
