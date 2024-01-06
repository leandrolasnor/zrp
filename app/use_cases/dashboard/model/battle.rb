# frozen_string_literal: true

class Dashboard::Model::Battle < ApplicationRecord
  belongs_to :hero
  belongs_to :threat
end
