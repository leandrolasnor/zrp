# frozen_string_literal: true

module CRUD::Create::Hero
  class Contract < ApplicationContract
    params do
      required(:name).filled(:string)
      required(:rank).type(:integer).value(included_in?: Model::Hero.ranks.values)
      required(:lat).filled(:float).value(:float)
      required(:lng).filled(:float).value(:float)
    end
  end
end
