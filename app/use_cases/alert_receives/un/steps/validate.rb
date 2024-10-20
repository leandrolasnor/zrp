# frozen_string_literal: true

module AlertReceives::UN
  class Steps::Validate
    include Dry::Monads[:result]
    include Dry.Types()
    extend  Dry::Initializer

    option :contract, type: Interface(:call), default: -> { Contract.new }, reader: :private

    def call(params)
      contract.call(params).to_monad
    end
  end
end
