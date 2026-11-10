# frozen_string_literal: true

class Http::ApplicationService
  private_class_method :new
  extend Dry::Initializer

  param :params, type: Types::Hash, reader: :private

  def self.call(args)
    if (contract = contract_class)
      result = contract.new.call(args.to_h)
      return [:unprocessable_entity, result.errors.to_hash] if result.failure?
    end

    new(args.to_h.symbolize_keys).call
  rescue ActiveRecord::RecordNotFound
    raise
  rescue StandardError => error
    Rails.logger.error(error)
    [:internal_server_error]
  end

  def self.contract_class
    return const_get(:Contract, false) if const_defined?(:Contract, false)
    return if name.nil?

    "#{name.deconstantize}::Contract".safe_constantize
  end
  private_class_method :contract_class
end
