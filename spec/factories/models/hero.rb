# frozen_string_literal: true

class Hero < ApplicationRecord
  include Enums::Hero::Rank
end
