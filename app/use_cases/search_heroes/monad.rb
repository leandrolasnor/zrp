# frozen_string_literal: true

class SearchHeroes::Monad
  include Dry::Monads[:try]
  extend  Dry::Initializer

  option :query, type: Types::Coercible::String, required: true, reader: :private
  option :page, type: Types::Coercible::Integer, default: -> { 1 }, reader: :private
  option :per_page, type: Types::Coercible::Integer, default: -> { 30 }, reader: :private
  option :filter, type: Types::Array(Types::String), default: -> { [] }, reader: :private
  option :sort, type: Types::Array(Types::String), default: -> { ['name:asc'] }, reader: :private
  option :hero, type: Types::Interface(:ms_raw_search), default: -> { SearchHeroes::Model::Hero }, reader: :private

  def call
    Try[MeiliSearch::ApiError] do
      hero.ms_raw_search(query, filter: filter, page: page, hits_per_page: per_page, sort: sort)
    end
  end
end
