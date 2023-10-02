# frozen_string_literal: true

class ThreatsHistory::Model::Hero < ApplicationRecord
  include Enums::Hero::Rank
end
