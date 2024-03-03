# frozen_string_literal: true

class DeallocateResource::Monad
  include Dry::Monads[:try]
  include Dry.Types()
  extend Dry::Initializer

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
      end
    end
  end
end
