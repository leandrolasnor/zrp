# frozen_string_literal: true

module Delete
  module Hero
    class Container
      extend Dry::Container::Mixin

      register 'find.step', -> { Steps::Find.new }
      register 'destroy.step', -> { Steps::Destroy.new }
    end
  end
end
