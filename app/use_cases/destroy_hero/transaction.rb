# frozen_string_literal: true

class DestroyHero::Transaction
  include Dry::Transaction(container: DestroyHero::Container)

  try :find, with: 'steps.find', catch: ActiveRecord::RecordNotFound
  try :destroy, with: 'steps.destroy', catch: StandardError
end
