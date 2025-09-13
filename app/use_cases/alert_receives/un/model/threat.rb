# frozen_string_literal: true

module AlertReceives::UN::Model
  class Threat < ApplicationRecord
    include ::AggregateRoot
    include Enums::Threat::Rank
    include Enums::Threat::AASM
    include Meilisearch::Rails
    include Indexes::Threat::Meilisearch

    after_save -> do
      Rails.configuration.event_store.publish(
        AlertReceived.new(data: payload),
        stream_name: "#{self.class.name}.find(#{self.id})"
      )
    end
  end
end
