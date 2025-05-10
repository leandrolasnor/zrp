# frozen_string_literal: true

class Dashboard::Widgets::HeroesDistribution::Monad
  include Dry::Monads[:try]
  extend Dry::Initializer

  option :model, type: Types::Interface(:ms_raw_search), default: -> { Dashboard::Model::Hero }, reader: :private
  option :ranks, type: Types::Array, default: -> { model.ranks.keys }, reader: :private

  def call
    Try do
      search = model.ms_raw_search('', page: 0, facets: [:rank])
      ranks.index_with { search['facetDistribution']['rank'][it] }.symbolize_keys
    end
  end
end
