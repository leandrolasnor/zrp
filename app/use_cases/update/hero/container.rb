# frozen_string_literal: true

module Update
  module Hero
    class Container
      extend Dry::Container::Mixin

      register 'steps.find', -> { Steps::Find.new }
      register 'steps.validate', -> { Steps::Validate.new }
      register 'steps.update', -> { Steps::Update.new }
    end

    module Steps
      class Find
        extend Dry::Initializer

        option :model, type: Types::Interface(:find, :lock), default: -> { Models::Hero }, reader: :private

        def call(params) = params.to_h.merge(record: model.lock.find(params[:id]))
      end

      class Validate
        extend Dry::Initializer

        option :contract, type: Types::Interface(:call), default: -> { Contract.new }, reader: :private

        def call(params) = contract.call(params).to_monad
      end

      class Update
        def call(record:, **params)
          record.update!(params)
          record
        end
      end
    end
  end
end
