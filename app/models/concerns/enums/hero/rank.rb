# frozen_string_literal: true

module Enums::Hero::Rank
  extend ActiveSupport::Concern

  included do
    enum :rank, [:s, :a, :b, :c]
  end
end
