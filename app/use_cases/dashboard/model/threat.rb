# frozen_string_literal: true

class Dashboard::Model::Threat < ApplicationRecord
  include Enums::Threat::Rank
  include Enums::Threat::Status
  include Scopes::Threat::Fresh

  has_many :battles
end
