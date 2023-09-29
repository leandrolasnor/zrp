# frozen_string_literal: true

class DeallocateResource::Model::Threat < ApplicationRecord
  has_many :battles
  has_many :heroes, through: :battles
end
