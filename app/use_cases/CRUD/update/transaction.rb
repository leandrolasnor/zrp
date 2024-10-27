# frozen_string_literal: true

class CRUD::Update::Transaction
  include Dry::Transaction

  step :validate, with: 'steps.validate'
  try :edit, with: 'steps.edit', catch: StandardError
end
