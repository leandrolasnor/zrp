# frozen_string_literal: true

module AlertReceives::UN
  class Container
    extend Dry::Container::Mixin

    register 'steps.validate',  -> { Steps::Validate.new }
    register 'steps.create',    -> { Steps::Create.new }
    register 'steps.notify',    -> { Steps::Notify.new }
  end

  module Steps
    class Validate
      extend Dry::Initializer

      option :contract, type: Types::Interface(:call), default: -> { Contract.new }, reader: :private
      def call(params) = contract.call(params).to_monad
    end

    class Create
      extend Dry::Initializer

      option :model, type: Types::Interface(:create), default: -> { Model::Threat }, reader: :private
      def call(res) = model.connection_pool.with_connection { model.create(res.to_h) }
    end

    class Notify
      def call(threat)
        AppEvents.publish('threat.created', threat:) if threat.enabled?
      end
    end
  end
end
