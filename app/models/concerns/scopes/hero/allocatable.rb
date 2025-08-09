# frozen_string_literal: true

module Scopes::Hero::Allocatable
  extend ActiveSupport::Concern

  included do
    scope :allocatable, -> (limit) do
      enabled.order(:updated_at).limit(limit).
        lock('FOR UPDATE SKIP LOCKED')
    end
  end
end
