# frozen_string_literal: true

class CreateHero::Contract < ApplicationContract
  params do
    required(:name).filled(:string)
    required(:rank).type(:integer).value(included_in?: CreateHero::Model::Hero.ranks.values)
    required(:lat).filled(:float).value(:float)
    required(:lng).filled(:float).value(:float)
  end
end
