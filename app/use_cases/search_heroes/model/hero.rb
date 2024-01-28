# frozen_string_literal: true

class SearchHeroes::Model::Hero < ApplicationRecord
  include MeiliSearch::Rails
  include Indexes::Hero::Meilisearch
end
