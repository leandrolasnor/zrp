# frozen_string_literal: true

class AllocateResource::Model::Battle < ApplicationRecord
  delegate :score!, to: :calculator

  belongs_to :hero
  belongs_to :threat

  private

  def calculator
    @calculator ||= AllocateResource::DomainService::Calculator::Battle.new(self)
  end
end
