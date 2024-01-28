# frozen_string_literal: true

class SearchHeroes::Monad
  include Dry::Monads[:try]
  include Dry.Types()
  extend  Dry::Initializer

  option :model, type: Interface(:ms_raw_search), default: -> { SearchHeroes::Model::Hero }, reader: :private

  def call(query:, page:, per_page:, sort: 'name:asc', **_)
    Try do
      model.ms_raw_search(query, page: page, hits_per_page: per_page, sort: [sort])
    end
  end
end
