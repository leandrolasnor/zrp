# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Http::ThreatsHistory::Contract do
  subject(:contract) { described_class.new }

  describe '.call' do
    context 'with a valid page' do
      it { expect(contract.call(page: 1)).to be_success }
    end

    context 'with a valid page and per_page' do
      it { expect(contract.call(page: 1, per_page: 25)).to be_success }
    end

    context 'with an invalid page' do
      it 'returns a page error' do
        result = contract.call(page: 'not-an-integer')

        expect(result).to be_failure
        expect(result.errors.to_hash).to include(:page)
      end
    end

    context 'without a page' do
      it 'returns a page error' do
        result = contract.call({})

        expect(result).to be_failure
        expect(result.errors.to_hash).to include(:page)
      end
    end
  end
end
