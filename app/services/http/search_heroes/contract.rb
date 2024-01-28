# frozen_string_literal: true

class Http::SearchHeroes::Contract < ApplicationContract
  params do
    required(:query).value(:string)
    required(:page).filled(:integer)
    required(:per_page).filled(:integer)
    optional(:sort).filled(:string).value(included_in?: ['name:asc', 'name:desc'])
  end
end
