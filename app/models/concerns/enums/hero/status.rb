# frozen_string_literal: true

module Enums::Hero::Status
  extend ActiveSupport::Concern

  included do
    enum :status, { disabled: 0, enabled: 1, working: 2 }
  end
end
