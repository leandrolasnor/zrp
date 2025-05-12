# frozen_string_literal: true

class Delete::Transaction
  include Dry::Transaction

  try :find, with: "find.step", catch: ActiveRecord::RecordNotFound
  try :destroy, with: "destroy.step", catch: ActiveRecord::RecordNotDestroyed
end
