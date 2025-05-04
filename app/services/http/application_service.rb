# frozen_string_literal: true

class Http::ApplicationService
  private_class_method :new
  extend Dry::Initializer

  param :params, type: Types::Hash, reader: :private

  def self.call(args)
    if defined?(self::Contract)
      args = self::Contract.new.(args.to_h)
      return [:unprocessable_entity, args.errors.to_h] if args.failure?
    end

    new(args.to_h.symbolize_keys).call
  rescue StandardError => error
    debugger if Rails.env.test?
    Rails.logger.info(args)
    Rails.logger.error(error)
    [:internal_server_error]
  end
end
