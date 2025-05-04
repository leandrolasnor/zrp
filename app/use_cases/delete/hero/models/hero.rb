# frozen_string_literal: true

class Delete::Hero::Models::Hero < ApplicationRecord
  acts_as_paranoid

  include Enums::Hero::Rank
  include Enums::Hero::Status
  include Meilisearch::Rails
  include Indexes::Hero::Meilisearch
end
