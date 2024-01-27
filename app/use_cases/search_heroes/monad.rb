# frozen_string_literal: true

class SearchHeroes::Monad
  include Dry::Monads[:try]
  include Dry.Types()
  extend  Dry::Initializer

  option :model, type: Interface(:page), default: -> { SearchHeroes::Model::Hero }, reader: :private

  def call(query: '', sort: ['name:asc'], limit: 25, offset: 0)
    Try do
      model.ms_raw_search(
        query,
        limit: limit,
        offset: offset,
        sort: sort
      )
    end
  end
end
