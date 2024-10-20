# frozen_string_literal: true

module AlertReceives::UN
  class Container
    extend Dry::Container::Mixin

    register 'steps.validate',  -> { Steps::Validate.new }
    register 'steps.create',    -> { Steps::Create.new }
    register 'steps.notify',    -> { Steps::Notify.new }
  end
end
