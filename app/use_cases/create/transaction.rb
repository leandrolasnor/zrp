# frozen_string_literal: true

class Create::Transaction
  include Dry::Transaction

  step :validate, with: "steps.validate"
  try :persist, with: "steps.persist", catch: StandardError
end
