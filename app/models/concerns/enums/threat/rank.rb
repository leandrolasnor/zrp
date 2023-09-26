# frozen_string_literal: true

module Enums::Threat::Rank
  extend ActiveSupport::Concern

  included do
    enum :rank, [:god, :dragon, :tiger, :wolf]
  end
end
