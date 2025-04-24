# frozen_string_literal: true

module Create::Hero
  class Contract < ApplicationContract
    params do
      required(:name).filled(:string)
      required(:rank).type(:string).value(max_size?: 1, included_in?: Models::Hero.ranks.keys)
      required(:lat).filled(:float).value(:float)
      required(:lng).filled(:float).value(:float)
    end
  end
end
