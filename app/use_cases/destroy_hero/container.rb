# frozen_string_literal: true

class DestroyHero::Container
  extend Dry::Container::Mixin

  register 'steps.find', -> { DestroyHero::Steps::Find.new }
  register 'steps.destroy', -> { DestroyHero::Steps::Destroy.new }
end
