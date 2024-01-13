# frozen_string_literal: true

class CreateThreat::Model::Threat < ApplicationRecord
  include Enums::Threat::Rank
  include Enums::Threat::Status
  include Indexes::Threat::Meilisearch
end
