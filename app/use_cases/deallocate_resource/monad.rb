# frozen_string_literal: true

class DeallocateResource::Monad
  include Dry::Monads[:try]
  include Dry::Events::Publisher[:resource_deallocated]
  include Dry.Types()
  extend Dry::Initializer

  register_event 'resource.deallocated'

  option :threat, type: Interface(:find), default: -> { DeallocateResource::Model::Threat }, reader: :private

  def call(id)
    Try do
      ApplicationRecord.transaction do
        record = threat.find(id).lock!
        record.touch
        record.disabled!
        record.heroes.each do
          _1.lock!
          _1.enabled!
        end
        publish('resource.deallocated', threat: record)
        record
      end
    end
  end
end
