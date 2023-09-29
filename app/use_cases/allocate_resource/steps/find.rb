# frozen_string_literal: true

class AllocateResource::Steps::Find
  include Dry::Monads[:result]
  include Dry.Types()
  extend  Dry::Initializer

  option :model, type: Interface(:find), default: -> { AllocateResource::Model::Threat }, reader: :private

  def call(id)
    model.find(id)
  end
end
