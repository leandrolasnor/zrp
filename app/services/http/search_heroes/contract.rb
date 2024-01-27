# frozen_string_literal: true

class Http::SearchHeroes::Contract < ApplicationContract
  module Types
    include Dry.Types()

    Pagination = Types::Hash.constructor do
      {
        limit: _1[:per_page],
        offset: (_1[:page] - 1) * _1[:per_page]
      }
    end
  end

  params do
    configure { config.type_specs = true }
    required(:pagination, Types::Pagination).hash do
      required(:page).filled(:integer)
      required(:per_page).filled(:integer)
    end
  end

  # params do
  #   required(:query).filled(:string)
  #   required(:limit).filled(:integer)
  #   required(:offset).filled(:integer)
  #   optional(:sort).array(:string)
  # end
end
