# frozen_string_literal: true

class DestroyHero::Model::Hero < ApplicationRecord
  include Enums::Hero::Rank
end
