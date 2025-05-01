# frozen_string_literal: true

module Http::ThreatsHistory
  class Contract < ApplicationContract
    params do
      required(:page).filled(:integer)
      optional(:per_page).filled(:integer)
    end
  end
end
