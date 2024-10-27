# frozen_string_literal: true

class CRUD::Create::Transaction
  include Dry::Transaction

  step :validate, with: 'steps.validate'
  try :create, with: 'steps.create', catch: StandardError
end
