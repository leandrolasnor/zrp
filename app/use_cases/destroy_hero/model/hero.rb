# frozen_string_literal: true

class DestroyHero::Model::Hero < ApplicationRecord
  acts_as_paranoid
  include Enums::Hero::Rank
  include Enums::Hero::Status
end
