# frozen_string_literal: true

class EditHero::Contract < ApplicationContract
  params do
    required(:id).filled(:integer)
    optional(:name).filled(:string)
    optional(:rank).type(:integer).value(included_in?: EditHero::Model::Hero.ranks.values)
    optional(:lat).filled(:float)
    optional(:lng).filled(:float)
  end
end
