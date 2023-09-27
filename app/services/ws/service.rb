# frozen_string_literal: true

class Ws::Service
  include Dry.Types()
  extend Dry::Initializer

  param :params, type: Hash, reader: :private

  def self.call(message)
    if defined?(self::Contract)
      contract = self::Contract.call(message)
      Rails.logger.error(contract.errors.to_h) if contract.failure?
      return
    end

    new(message).call
  rescue StandardError => error
    Rails.logger.error(error)
  end
end
