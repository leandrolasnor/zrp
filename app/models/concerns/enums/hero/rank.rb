# frozen_string_literal: true

module Enums::Hero::Rank
  extend ActiveSupport::Concern

  included do
    enum :rank, { c: 0, b: 1, a: 2, s: 3 }
  end
end
