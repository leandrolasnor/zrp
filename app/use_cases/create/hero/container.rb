# frozen_string_literal: true

module Create
  module Hero
    class Container
      extend Dry::Container::Mixin

      register 'validate.step', -> { Steps::Validate.new }
      register 'persist.step', -> { Steps::Persist.new }
    end
  end
end
