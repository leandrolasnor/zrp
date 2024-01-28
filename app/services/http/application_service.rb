# frozen_string_literal: true

class Http::ApplicationService
  include Dry.Types()
  extend Dry::Initializer

  param :params, type: Hash, reader: :private

  def self.call(args)
    if defined?(self::Contract)
      args = self::Contract.call(args.to_h)
      return [:unprocessable_entity, args.errors.to_h] if args.failure?
    end

    new(args.to_h).call
  rescue StandardError => error
    Rails.logger.error(error)
    [:internal_server_error]
  end
end
