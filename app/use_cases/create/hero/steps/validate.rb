# frozen_string_literal: true

module Create::Hero
  module Steps
    class Validate
      extend Dry::Initializer

      option :contract, type: Types::Interface(:call), default: -> { Contract.new }, reader: :private

      def call(params) = contract.call(params).to_monad
    end
  end
end
