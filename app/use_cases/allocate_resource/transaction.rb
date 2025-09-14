# frozen_string_literal: true

class AllocateResource::Transaction
  include Dry::Transaction(container: AllocateResource::Container)

  try :find, with: 'steps.find', catch: ActiveRecord::RecordNotFound
  try :matches, with: 'steps.matches', catch: StandardError
  map :sort, with: 'steps.sort'
  try :allocate, with: 'steps.allocate', catch: StandardError
end
