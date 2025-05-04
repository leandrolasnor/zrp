# frozen_string_literal: true

module AlertReceives::UN
  class Steps::Validate
    extend Dry::Initializer

    option :contract, type: Types::Interface(:call), default: -> { Contract.new }, reader: :private
    def call(params) = contract.call(params).to_monad
  end
end
