# frozen_string_literal: true

class ShowHero::Monad
  include Dry::Monads[:result, :try]
  include Dry.Types()
  extend  Dry::Initializer

  option :model, type: Interface(:find), default: -> { ShowHero::Model::Hero }, reader: :private

  def call(id)
    Try(ActiveRecord::RecordNotFound) { model.find(id) }
  end
end
