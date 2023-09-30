# frozen_string_literal: true

class DeallocateResource::Model::Battle < ApplicationRecord
  belongs_to :threat
  belongs_to :hero
end
