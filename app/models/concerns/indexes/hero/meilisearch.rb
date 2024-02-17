# frozen_string_literal: true

module Indexes::Hero::Meilisearch
  extend ActiveSupport::Concern

  included do
    meilisearch index_uid: :hero do
      attribute :name
      attribute :rank
      attribute :status
      attribute :lat
      attribute :lng
      displayed_attributes [:id, :name, :rank, :status, :lat, :lng]
      searchable_attributes [:name, :rank, :status]
      sortable_attributes [:name, :rank, :status]
      filterable_attributes [:status]
    end
  end
end
