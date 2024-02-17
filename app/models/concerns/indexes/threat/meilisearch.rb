# frozen_string_literal: true

module Indexes::Threat::Meilisearch
  extend ActiveSupport::Concern

  included do
    meilisearch index_uid: :threat do
      attribute :name
      attribute :rank
      attribute :status
      attribute :payload
      attribute :created_at do
        created_at.to_time.to_i
      end
      displayed_attributes [:id, :name, :rank, :status, :payload]
      searchable_attributes [:name, :rank, :payload]
      sortable_attributes [:name, :rank, :status]
      filterable_attributes [:created_at, :status, :rank]
    end
  end
end
