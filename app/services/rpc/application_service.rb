# frozen_string_literal: true

class Rpc::ApplicationService
  private_class_method :new
  include Dry.Types()
  extend Dry::Initializer

  param :params, type: Strict::Hash, reader: :private

  def self.call(params)
    new(params).call
  end
end
