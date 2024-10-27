# frozen_string_literal: true

class CRUD::Update::Hero::Model::Hero < ApplicationRecord
  include Enums::Hero::Rank
  include Enums::Hero::Status
  include MeiliSearch::Rails
  include Indexes::Hero::Meilisearch

  after_touch :index!
end
