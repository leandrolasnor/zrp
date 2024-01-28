# frozen_string_literal: true

class ListHeroes::Monad
  include Dry::Monads[:try]
  include Dry.Types()
  extend  Dry::Initializer

  option :model, type: Interface(:page), default: -> { ListHeroes::Model::Hero }, reader: :private

  def call(page: 1, per_page: 25)
    Try { model.page(page).per(per_page).order(id: :desc) }
  end
end
