# frozen_string_literal: true

class EditHero::Container
  extend Dry::Container::Mixin

  register 'steps.validate', -> { EditHero::Steps::Validate.new }
  register 'steps.edit', -> { EditHero::Steps::Edit.new }
end
