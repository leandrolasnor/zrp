# frozen_string_literal: true

module CRUD::Create::Hero
  class Container
    extend Dry::Container::Mixin

    register 'steps.validate', -> { Steps::Validate.new }
    register 'steps.create', -> { Steps::Create.new }
  end
end
