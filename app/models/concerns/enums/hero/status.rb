# frozen_string_literal: true

module Enums::Hero::Status
  extend ActiveSupport::Concern

  included do
    enum :status, [:disabled, :enabled, :working]
  end
end
