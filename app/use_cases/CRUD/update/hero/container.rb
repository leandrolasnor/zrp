# frozen_string_literal: true

module CRUD::Update::Hero
  class Container
    extend Dry::Container::Mixin

    register 'steps.validate', -> { Steps::Validate.new }
    register 'steps.edit', -> { Steps::Edit.new }
  end
end
