# frozen_string_literal: true

class AllocateResource::Model::Hero < ApplicationRecord
  include Enums::Hero::Rank
  include Enums::Hero::Status
end
