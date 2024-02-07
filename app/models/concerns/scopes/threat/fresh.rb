# frozen_string_literal: true

module Scopes::Threat::Fresh
  extend ActiveSupport::Concern

  included do
    scope :fresh, -> { where(created_at: 20.minutes.ago..::Time.zone.now) }
  end
end
