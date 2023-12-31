# frozen_string_literal: true

class ThreatsHistory::Monad
  include Dry::Monads[:result, :try]
  include Dry.Types()
  extend  Dry::Initializer

  option :model, type: Interface(:page), default: -> { ThreatsHistory::Model::Threat }, reader: :private

  def call(page: 1, per_page: 25)
    Try { model.disabled.includes([:battles, :heroes]).page(page).per(per_page).order(id: :desc) }
  end
end
