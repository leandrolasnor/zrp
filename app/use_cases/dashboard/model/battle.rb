# frozen_string_literal: true

class Dashboard::Model::Battle < ApplicationRecord
  include Scopes::Battle::Fresh
  include MeiliSearch::Rails
  include Indexes::Battle::Meilisearch
  belongs_to :threat
end
