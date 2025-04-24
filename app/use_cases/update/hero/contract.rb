# frozen_string_literal: true

module Update::Hero
  class Contract < ApplicationContract
    params do
      required(:id).filled(:integer)
      optional(:name).filled(:string)
      optional(:rank).type(:string).value(max_size?: 1, included_in?: Models::Hero.ranks.keys)
      optional(:lat).filled(:float)
      optional(:lng).filled(:float)
    end
  end
end
