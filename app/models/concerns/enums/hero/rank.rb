# frozen_string_literal: true

module Enums::Hero::Rank
  extend ActiveSupport::Concern

  included do
    enum :rank, [:c, :b, :a, :s]
  end
end
