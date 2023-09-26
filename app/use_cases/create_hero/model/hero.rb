# frozen_string_literal: true

class CreateHero::Model::Hero < ApplicationRecord
  include Enums::Hero::Rank
end
