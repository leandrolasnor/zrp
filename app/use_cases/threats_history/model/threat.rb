# frozen_string_literal: true

class ThreatsHistory::Model::Threat < ApplicationRecord
  include Enums::Threat::Rank
  include Enums::Threat::Status
  include Scopes::Threat::Fresh

  has_many :battles
  has_many :heroes, through: :battles
end
