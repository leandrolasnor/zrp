# frozen_string_literal: true

class EditHero::Transaction
  include Dry::Transaction(container: EditHero::Container)

  step :validate, with: 'steps.validate'
  try :edit, with: 'steps.edit', catch: StandardError
end
