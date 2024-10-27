# frozen_string_literal: true

class CRUD::Delete::Transaction
  include Dry::Transaction

  try :find, with: 'steps.find', catch: ActiveRecord::RecordNotFound
  try :delete, with: 'steps.delete', catch: StandardError
end
