# frozen_string_literal: true

class AllocateResource::Model::Threat < ApplicationRecord
  include Enums::Threat::Rank
  include Enums::Threat::Status

  has_many :battles
  has_many :heroes, through: :battles
end
