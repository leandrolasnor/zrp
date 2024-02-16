# frozen_string_literal: true

class Ws::ApplicationService
  extend Dry::Monads[:result, :maybe]
  include Dry.Types()
  extend Dry::Initializer

  param :params, type: Hash, reader: :private

  def self.call(message)
    if defined?(self::Contract)
      message = self::Contract.call(message)
      return message.to_monad if message.failure?
    end

    new(message.to_h).call
  rescue StandardError => error
    Rails.logger.error(error)
    Failure().to_maybe
  end
end
