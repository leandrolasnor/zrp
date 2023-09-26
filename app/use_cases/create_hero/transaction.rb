# frozen_string_literal: true

class CreateHero::Transaction
  include Dry::Transaction(container: CreateHero::Container)

  step :validate, with: 'steps.validate'
  try :create, with: 'steps.create', catch: StandardError
end
