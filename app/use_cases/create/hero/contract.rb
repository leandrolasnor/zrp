# frozen_string_literal: true

module Create::Hero
  class Contract < ApplicationContract
    DECIMAL_PRECISION = 18
    DECIMAL_SCALE = 15

    params do
      required(:name).filled(:string)
      required(:rank).type(:string).value(max_size?: 1, included_in?: Models::Hero.ranks.keys)
      required(:lat).filled(:float)
      required(:lng).filled(:float)
    end

    rule(:lat).validate(decimal_fit: [DECIMAL_PRECISION, DECIMAL_SCALE])
    rule(:lng).validate(decimal_fit: [DECIMAL_PRECISION, DECIMAL_SCALE])
  end
end
