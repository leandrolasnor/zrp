# frozen_string_literal: true

module Indexes::Threat::Meilisearch
  extend ActiveSupport::Concern

  included do
    meilisearch index_uid: :threat do
      attribute :name
      attribute :rank
      attribute :status
      attribute :payload
      displayed_attributes [:id, :name, :rank, :status, :payload]
      searchable_attributes [:name, :rank, :payload]
      sortable_attributes [:name, :rank, :status]
    end
  end
end
