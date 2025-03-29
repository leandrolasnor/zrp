# frozen_string_literal: true

module Enums::Threat::Status
  extend ActiveSupport::Concern

  included do
    enum :status, { problem: 0, enabled: 1, disabled: 2, working: 3 }
  end
end
