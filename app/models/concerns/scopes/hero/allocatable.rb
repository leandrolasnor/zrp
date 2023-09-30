# frozen_string_literal: true

module Scopes::Hero::Allocatable
  extend ActiveSupport::Concern

  included do
    scope :allocatable, -> (limit) { enabled.order(:updated_at).limit(limit) }
  end
end
