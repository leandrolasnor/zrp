# frozen_string_literal: true

class Dashboard::Model::Hero < ApplicationRecord
  include Enums::Hero::Rank
  include Enums::Hero::Status
  include MeiliSearch::Rails
  include Indexes::Hero::Meilisearch

  has_many :battles
end
