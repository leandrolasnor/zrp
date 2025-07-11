# frozen_string_literal: true

class Http::Sse::ApplicationService
  private_class_method :new
  include ActionController::Live
  extend Dry::Initializer

  param :params, type: Types::Hash, reader: :private
  option :sse, type: Types::Interface(:write), reader: :private

  def self.call(response:, **args)
    response.headers['Content-Type'] = 'text/event-stream'
    response.headers['Last-Modified'] = ::Time.now.httpdate
    sse = SSE.new(response.stream)

    if defined?(self::Contract)
      contract = self::Contract.call(args.to_h)
      if contract.failure?
        sse.write(type: 'CONTRACT_ERROR', payload: contract.errors.to_h)
        sse.close
        return
      end
    end

    new(args, sse:).call
  rescue ActionController::Live::ClientDisconnected
    sse.close
  rescue StandardError => error
    Rails.logger.error(error)
  ensure
    sse.close
  end
end
