# frozen_string_literal: true

class Update::Hero::Models::Hero < ApplicationRecord
  include Enums::Hero::Rank
  include Enums::Hero::Status
  include Meilisearch::Rails
  include Indexes::Hero::Meilisearch
end
