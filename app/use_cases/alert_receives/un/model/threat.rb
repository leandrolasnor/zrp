# frozen_string_literal: true

module AlertReceives::UN::Model
  class Threat < ApplicationRecord
    include Enums::Threat::Rank
    include Enums::Threat::Status
    include Enums::Threat::AASM
    include Meilisearch::Rails
    include Indexes::Threat::Meilisearch
  end
end
