# frozen_string_literal: true

class Rpc::ApplicationService
  private_class_method :new
  extend Dry::Initializer

  param :params, type: Types::Strict::Hash, reader: :private

  def self.call(args) = new(args.to_h).call
end
