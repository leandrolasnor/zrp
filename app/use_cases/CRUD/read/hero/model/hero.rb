# frozen_string_literal: true

class CRUD::Read::Hero::Model::Hero < ApplicationRecord
  include Enums::Hero::Rank
  include Enums::Hero::Status
end
