# frozen_string_literal: true

module Indexes::Hero::Meilisearch
  extend ActiveSupport::Concern
  include MeiliSearch::Rails

  included do
    meilisearch auto_index: !Rails.env.test?, auto_remove: Rails.env.test?
    meilisearch index_uid: :hero do
      attribute :name
      attribute :rank
      attribute :status
      attribute :lat
      attribute :lng
      displayed_attributes [:id, :name, :rank, :status, :lat, :lng]
      searchable_attributes [:name, :rank, :status]
      sortable_attributes [:name, :rank, :status]
    end
  end
end
