# frozen_string_literal: true

require 'rails_helper'
RSpec.describe AllocateResource::DomainService::Calculator::Battle do
  describe '.score!' do
    subject { described_class.new(build(:battle, :allocate_resource)) }

    it 'must be able to calculate battle score' do
      expect(subject.score!).to be_integer
    end
  end
end
