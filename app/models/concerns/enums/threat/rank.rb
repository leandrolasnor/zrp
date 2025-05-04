# frozen_string_literal: true

module Enums::Threat::Rank
  extend ActiveSupport::Concern

  included do
    enum :rank, { wolf: 0, tiger: 1, dragon: 2, god: 3 }
  end
end
