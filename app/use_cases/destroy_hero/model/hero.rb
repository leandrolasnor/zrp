# frozen_string_literal: true

class DestroyHero::Model::Hero < ApplicationRecord
  acts_as_paranoid
  include Enums::Hero::Status
  include MeiliSearch::Rails
  include Indexes::Hero::Meilisearch
end
