# frozen_string_literal: true

class DeallocateResource::Model::Hero < ApplicationRecord
  include Enums::Hero::Status
  include Enums::Hero::Rank
  include Meilisearch::Rails
  include Indexes::Hero::Meilisearch
end
