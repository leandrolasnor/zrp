# frozen_string_literal: true

class Dashboard::Widgets::HeroesDistribution::Monad
  include Dry::Monads[:try]
  include Dry.Types()
  extend Dry::Initializer

  option :model, type: Interface(:ms_raw_search), default: -> { Dashboard::Model::Hero }, reader: :private
  option :ranks, type: Array, default: -> { model.ranks.keys }, reader: :private

  def call
    Try do
      search = model.ms_raw_search(
        '',
        page: 0,
        facets: [:rank]
      )

      count = ranks.map do
        [_1, search['facetDistribution']['rank'][_1]]
      end

      count.to_h.symbolize_keys
    end
  end
end
