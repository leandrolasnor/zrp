# frozen_string_literal: true

class DeallocateResource::Monad
  include Dry::Monads[:try]
  extend Dry::Initializer

  option :threat, type: Types::Interface(:find), default: -> { DeallocateResource::Model::Threat }, reader: :private

  def call(id)
    Try do
      ApplicationRecord.transaction do
        record = threat.lock.find(id)
        record.touch
        record.disabled!
        record.heroes.lock.each(&:enabled!)
        AppEvents.publish('resource.deallocated', threat: record)
        record
      end
    end
  end
end
