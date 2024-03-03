# frozen_string_literal: true

class DeallocateResource::Model::Threat < ApplicationRecord
  include Enums::Threat::Status
  include Enums::Threat::Rank
  include MeiliSearch::Rails
  include Indexes::Threat::Meilisearch

  has_many :battles
  has_many :heroes, through: :battles
end
