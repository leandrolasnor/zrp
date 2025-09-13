# frozen_string_literal: true

class Update::Transaction
  include Dry::Transaction

  step :validate, with: "steps.validate"
  try :find, with: "steps.find", catch: ActiveRecord::RecordNotFound
  try :update, with: "steps.update", catch: StandardError
end
