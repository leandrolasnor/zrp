# frozen_string_literal: true

require 'rails_helper'
RSpec.describe RemoveFromIndex::Monad do
  let(:call) { described_class.new(id:, model:).() }

  describe '.call' do
    let(:id) { 20 }
    let(:model) { Delete::Hero::Models::Hero }

    it 'must be able to call and get a success' do
      expect(call.to_result).to be_success
    end
  end
end
