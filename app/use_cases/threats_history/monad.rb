# frozen_string_literal: true

class ThreatsHistory::Monad
  include Dry::Monads[:try]
  include Dry.Types()
  extend  Dry::Initializer

  option :threat, type: Interface(:page), default: -> { ThreatsHistory::Model::Threat }, reader: :private

  def call(page: 1, per_page: 25)
    Try do
      threat.fresh.disabled
        .includes([:battles, :heroes])
        .page(page).per(per_page)
        .order('battles.finished_at desc')
    end
  end
end
