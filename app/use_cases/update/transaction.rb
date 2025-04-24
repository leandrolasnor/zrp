# frozen_string_literal: true

class Update::Transaction
  include Dry::Transaction

  step :validate, with: "validate.step"
  try :find, with: "find.step", catch: ActiveRecord::RecordNotFound
  try :update, with: "update.step", catch: StandardError
end
