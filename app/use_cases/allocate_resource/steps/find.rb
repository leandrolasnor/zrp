# frozen_string_literal: true

class AllocateResource::Steps::Find
  include Dry::Monads[:result]

  extend  Dry::Initializer

  option :threat, type: Types::Interface(:find), default: -> { AllocateResource::Model::Threat }, reader: :private

  def call(id) = threat.enabled.lock.find(id)
end
