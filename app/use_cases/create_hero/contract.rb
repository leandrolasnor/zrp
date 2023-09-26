# frozen_string_literal: true

class CreateHero::Contract < ApplicationContract
  params do
    required(:name).filled(:string)
    required(:rank).type(:integer).value(included_in?: EditHero::Model::Hero.ranks.values)
    required(:lat).filled(:float)
    required(:lng).filled(:float)
  end
end
