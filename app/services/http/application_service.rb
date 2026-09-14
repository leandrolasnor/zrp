# frozen_string_literal: true

class Http::ApplicationService
  private_class_method :new
  extend Dry::Initializer

  param :params, type: Types::Hash, reader: :private

  def self.call(args)
    if defined?(self::Contract)
      contract = self::Contract.new.(args.to_h)
      return [:unprocessable_entity, contract.errors] if contract.failure?
    end

    new(args.to_h.symbolize_keys).call
  rescue StandardError => error
    Rails.logger.info(args)
    Rails.logger.error(error)
    [:internal_server_error]
  end
end
