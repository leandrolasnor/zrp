# frozen_string_literal: true

class SearchHeroes::Monad
  include Dry::Monads[:try]
  extend  Dry::Initializer

  option :hero, type: Types::Interface(:ms_raw_search), default: -> { SearchHeroes::Model::Hero }, reader: :private

  def call(query:, filter:, page:, per_page:, sort: ['name:asc'], **_)
    Try[MeiliSearch::ApiError] do
      hero.ms_raw_search(query, filter: filter, page: page, hits_per_page: per_page, sort: sort)
    end
  end
end
