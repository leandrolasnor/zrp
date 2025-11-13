# frozen_string_literal: true

class ShortenedUrlsController < ApplicationController
  def create
    status, content, serializer = Http::CreateShortenedUrl::Service.(create_params)
    render json: content, status:, serializer:
  end

  def redirect
    status, content = Http::RedirectShortenedUrl::Service.(params.permit(:code))
    if status == :found
      redirect_to content[:original_url], status: :found
    else
      render json: content, status:
    end
  end

  private

  def create_params = params.required(:shortened_url).permit(:original_url)
end
