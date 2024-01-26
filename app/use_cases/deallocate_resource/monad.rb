# frozen_string_literal: true

class DeallocateResource::Monad
  include Dry::Monads[:try]
  include Dry.Types()
  extend Dry::Initializer

  option :model, type: Interface(:find), default: -> { DeallocateResource::Model::Threat }, reader: :private

  def call(id)
    Try do
      ApplicationRecord.transaction do
        threat = model.find(id).lock!
        threat.touch
        threat.disabled!
        threat.heroes.each do
          _1.lock!
          _1.enabled!
        end
      end
    end
  end
end
