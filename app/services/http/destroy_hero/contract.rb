# frozen_string_literal: true

class Http::DestroyHero::Contract < ApplicationContract
  params do
    required(:id).filled(:integer)
  end
end
