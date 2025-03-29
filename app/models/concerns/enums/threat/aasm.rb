# frozen_string_literal: true

module Enums::Threat::AASM
  extend ActiveSupport::Concern

  included do
    include AASM

    aasm column: :status do
      state :enabled, initial: true
      state :problem, :disabled, :working

      event :working do
        transitions from: %i[enabled working], to: :working
      end

      event :problem do
        transitions from: %i[enabled disabled problem], to: :problem
      end

      event :disabled do
        transitions from: %i[working problem disabled], to: :disabled
      end
    end
  end
end
