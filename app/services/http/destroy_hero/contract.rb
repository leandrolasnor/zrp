# frozen_string_literal: true

module Http::DestroyHero
  class Contract < ApplicationContract
    params do
      required(:id).filled(:integer)
    end
  end
end
