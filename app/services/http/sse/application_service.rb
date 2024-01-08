# frozen_string_literal: true

class Http::Sse::ApplicationService
  include ActionController::Live
  include Dry.Types()
  extend Dry::Initializer

  param :params, type: Hash, reader: :private
  option :sse, type: Interface(:write), default: -> { params[:sse] }, reader: :private

  def self.call(response:, **args)
    response.headers['Content-Type'] = 'text/event-stream'
    response.headers['Last-Modified'] = ::Time.now.httpdate
    sse = SSE.new(response.stream)

    if defined?(self::Contract)
      contract = self::Contract.call(args.to_h)
      if contract.failure?
        sse.write({ type: 'CONTRACT_ERROR', payload: contract.errors.to_h })
        sse.close
        return
      end
    end

    new(args.merge(sse: sse)).call
  rescue StandardError => error
    Rails.logger.error(error)
  ensure
    sse.close
  end
end
