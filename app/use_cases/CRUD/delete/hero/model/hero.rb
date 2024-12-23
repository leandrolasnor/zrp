# frozen_string_literal: true

class CRUD::Delete::Hero::Model::Hero < ApplicationRecord
  acts_as_paranoid
  include Enums::Hero::Rank
  include Enums::Hero::Status
  include MeiliSearch::Rails
  include Indexes::Hero::Meilisearch
end
