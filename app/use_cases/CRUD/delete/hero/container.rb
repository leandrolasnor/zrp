# frozen_string_literal: true

module CRUD::Delete::Hero
  class Container
    extend Dry::Container::Mixin

    register 'steps.find', -> { Steps::Find.new }
    register 'steps.delete', -> { Steps::Delete.new }
  end
end
