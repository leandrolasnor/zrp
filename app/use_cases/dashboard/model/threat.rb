# frozen_string_literal: true

class Dashboard::Model::Threat < ApplicationRecord
  include Enums::Threat::Rank
  include Enums::Threat::Status

  has_many :battles
end
