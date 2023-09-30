# frozen_string_literal: true

class Threat < ApplicationRecord
  include Enums::Threat::Rank
end
