# frozen_string_literal: true

class DeallocateResource::Model::Threat < ApplicationRecord
  include Enums::Threat::Status
  include Indexes::Threat::Meilisearch

  has_many :battles
  has_many :heroes, through: :battles
end
