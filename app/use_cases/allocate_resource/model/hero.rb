# frozen_string_literal: true

class AllocateResource::Model::Hero < ApplicationRecord
  include Enums::Hero::Rank
  include Enums::Hero::AASM
  include Scopes::Hero::Allocatable
  include Meilisearch::Rails
  include Indexes::Hero::Meilisearch
end
