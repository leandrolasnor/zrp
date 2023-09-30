# frozen_string_literal: true

class DeallocateResource::Model::Threat < ApplicationRecord
  include Enums::Threat::Status

  has_many :battles
  has_many :heroes, through: :battles
end
