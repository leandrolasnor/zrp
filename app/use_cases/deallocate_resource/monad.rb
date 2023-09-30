# frozen_string_literal: true

class DeallocateResource::Monad
  include Dry::Monads[:result, :try]
  include Dry.Types()
  extend Dry::Initializer

  option :model, type: Interface(:find), default: -> { DeallocateResource::Model::Threat }, reader: :private

  def call(id)
    Try { model.find(id) }.fmap { _1.disabled! && _1.touch && _1 }.fmap { _1.heroes.map(&:enabled!) && _1 }
  end
end
