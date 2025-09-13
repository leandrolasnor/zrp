# frozen_string_literal: true

module Enums::Hero::AASM
  extend ActiveSupport::Concern

  included do
    include AASM

    aasm column: :status do
      state :enabled, initial: true
      state :working, :disabled

      event :working do
        transitions from: %i[enabled working], to: :working
      end

      event :disabled do
        transitions from: %i[enabled working disabled], to: :disabled
      end
    end

    include Enums::Hero::Status
  end
end
