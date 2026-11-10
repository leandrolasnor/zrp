# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Http::DestroyHero::Contract do
  subject(:contract) { described_class.new }

  describe '.call' do
    context 'with a valid id' do
      it { expect(contract.call(id: 1)).to be_success }
    end

    context 'with an invalid id' do
      it 'returns an id error' do
        result = contract.call(id: 'not-an-integer')

        expect(result).to be_failure
        expect(result.errors.to_hash).to include(:id)
      end
    end
  end
end
