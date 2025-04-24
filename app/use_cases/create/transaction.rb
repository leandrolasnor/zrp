# frozen_string_literal: true

class Create::Transaction
  include Dry::Transaction

  step :validate, with: "validate.step"
  try :persist, with: "persist.step", catch: StandardError
end
