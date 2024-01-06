# frozen_string_literal: true

class Dashboard::Model::Hero < ApplicationRecord
  include Enums::Hero::Rank
  include Enums::Hero::Status
  include Scopes::Hero::Allocatable
end
