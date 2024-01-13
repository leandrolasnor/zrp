# frozen_string_literal: true

module Indexes::Battle::Meilisearch
  extend ActiveSupport::Concern

  included do
    meilisearch auto_index: !Rails.env.test?, auto_remove: Rails.env.test?
    meilisearch index_uid: :battle do
      attribute :score
      attribute :finished_at
      attribute :hero do
        hero.name
      end
      attribute :threat do
        threat.name
      end
      attribute :lat do
        threat.lat
      end
      attribute :lng do
        threat.lng
      end
      displayed_attributes [:id, :score, :hero, :threat, :lat, :lng]
      searchable_attributes [:score, :hero, :threat]
      sortable_attributes [:score, :threat]
    end
  end
end
