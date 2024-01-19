# frozen_string_literal: true

class Dashboard::Model::Battle < ApplicationRecord
  include Scopes::Battle::Fresh
  belongs_to :threat
end
