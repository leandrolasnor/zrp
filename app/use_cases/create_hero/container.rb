# frozen_string_literal: true

class CreateHero::Container
  extend Dry::Container::Mixin

  register 'steps.validate', -> { CreateHero::Steps::Validate.new }
  register 'steps.create', -> { CreateHero::Steps::Create.new }
end
