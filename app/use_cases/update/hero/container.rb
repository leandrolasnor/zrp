# frozen_string_literal: true

module Update
  module Hero
    class Container
      extend Dry::Container::Mixin

      register 'find.step', -> { Steps::Find.new }
      register 'validate.step', -> { Steps::Validate.new }
      register 'update.step', -> { Steps::Update.new }
    end
  end
end
