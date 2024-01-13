# frozen_string_literal: true

class CreateHero::Model::Hero < ApplicationRecord
  include Enums::Hero::Rank
  include Enums::Hero::Status
  include Indexes::Hero::Meilisearch
end
