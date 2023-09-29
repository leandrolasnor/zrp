# frozen_string_literal: true

class DeallocateResource::Monad
  include Dry::Monads[:result, :try]
  include Dry.Types()
  extend Dry::Initializer

  option :model, type: Interface(:find), default: -> { DeallocateResource::Model::Threat }, reader: :private

  def call(id)
    Try { model.find(id).heroes.map(&:enabled!) }
  end
end
