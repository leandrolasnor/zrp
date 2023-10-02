# frozen_string_literal: true

module Enums::Threat::Status
  extend ActiveSupport::Concern

  included do
    enum :status, [:problem, :enabled, :disabled, :working]
  end
end
