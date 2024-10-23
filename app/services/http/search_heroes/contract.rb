# frozen_string_literal: true

class Http::SearchHeroes::Contract < ApplicationContract
  params do
    required(:query).value(:string)
    required(:filter).array(:str?)
    required(:page).filled(:integer)
    required(:per_page).filled(:integer)
    optional(:sort).filled(:string).value(included_in?: ['name:asc', 'name:desc'])
  end

  rule(:filter).each do
    key.failure(:filter_invalid) unless /^\s*([^\s=]+)\s*=\s*'([^']+)'\s*$/.match?(value)
  end
end
