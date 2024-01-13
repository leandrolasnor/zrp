# frozen_string_literal: true

class DeallocateResource::Model::Hero < ApplicationRecord
  include Enums::Hero::Statusin
  include Indexes::Hero::Meilisearch
end
