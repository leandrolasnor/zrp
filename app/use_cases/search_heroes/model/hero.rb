# frozen_string_literal: true

class SearchHeroes::Model::Hero < ApplicationRecord
  include Meilisearch::Rails
  include Indexes::Hero::Meilisearch
end
