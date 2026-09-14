# frozen_string_literal: true

class SSE::ApplicationController < ApiController
  include ActionController::Live

  rescue_from StandardError, with: :handle_error
  rescue_from JSON::ParserError, with: :handle_error
  rescue_from ActionController::Live::ClientDisconnected do end;
  before_action :set_headers

  private

  def handle_error(error) = Rails.logger.error error.full_message
  def sse = @sse ||= SSE.new(response.stream, retry: 3000)
  def redis = @redis ||= Redis.new(url: ENV.fetch('REDIS_URL', 'redis://localhost:6379/0'))

  def set_headers
    response.headers['Content-Type'] = 'text/event-stream'
    response.headers['Cache-Control'] = 'no-cache'
    response.headers['Connection'] = 'keep-alive'
    response.headers['X-Accel-Buffering'] = 'no'
  end

end
