# frozen_string_literal: true

class Delete::Transaction
  include Dry::Transaction

  try :find, with: "steps.find", catch: ActiveRecord::RecordNotFound
  try :destroy, with: "steps.destroy", catch: ActiveRecord::RecordNotDestroyed
end
