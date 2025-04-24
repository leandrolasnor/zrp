# frozen_string_literal: true

class Create::Hero::Models::Hero < ApplicationRecord
  include Enums::Hero::Rank
  include Enums::Hero::Status
  include MeiliSearch::Rails
  include Indexes::Hero::Meilisearch
end
