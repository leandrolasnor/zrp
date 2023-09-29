# frozen_string_literal: true

class AllocateResource::Container
  extend Dry::Container::Mixin

  register 'steps.find', -> { AllocateResource::Steps::Find.new }
  register 'steps.matches', -> { AllocateResource::Steps::Matches.new }
  register 'steps.sort', -> { AllocateResource::Steps::Sort.new }
  register 'steps.allocate', -> { AllocateResource::Steps::Allocate.new }
end
