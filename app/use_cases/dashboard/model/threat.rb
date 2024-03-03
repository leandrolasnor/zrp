# frozen_string_literal: true

class Dashboard::Model::Threat < ApplicationRecord
  include Enums::Threat::Rank
  include Enums::Threat::Status
  include Scopes::Threat::Fresh
  include MeiliSearch::Rails
  include Indexes::Threat::Meilisearch

  has_many :battles
end
