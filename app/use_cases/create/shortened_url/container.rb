# frozen_string_literal: true

module Create
  module ShortenedUrl
    class Container
      extend Dry::Container::Mixin

      register 'steps.validate', -> { Steps::Validate.new }
      register 'steps.persist', -> { Steps::Persist.new }
    end

    module Steps
      class Validate
        extend Dry::Initializer

        option :contract, type: Types::Interface(:call), default: -> { Contract.new }, reader: :private

        def call(params) = contract.call(params).to_monad
      end

      class Persist
        extend Dry::Initializer

        option :model, type: Types::Interface(:create), default: -> { Models::ShortenedUrl }, reader: :private

        def call(params) = model.create(params)
      end
    end
  end
end
