# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Http::SearchHeroes::Contract do
  subject(:contract) { described_class.new }

  let(:params) do
    {
      query: 'hero',
      filter: ["rank = 's'"],
      page: 1,
      per_page: 10,
      sort: ['name:asc']
    }
  end

  describe '.call' do
    context 'with valid params' do
      it { expect(contract.call(params)).to be_success }
    end

    context 'without a filter' do
      let(:params) { super().except(:filter) }

      it { expect(contract.call(params)).to be_success }
    end

    context 'with an empty filter' do
      let(:params) { super().merge(filter: []) }

      it { expect(contract.call(params)).to be_success }
    end

    context 'with an invalid filter' do
      let(:params) { super().merge(filter: ['invalid filter']) }

      it 'returns a filter error' do
        result = contract.call(params)

        expect(result).to be_failure
        expect(result.errors.to_hash).to include(:filter)
      end
    end

    context 'with an invalid sort' do
      let(:params) { super().merge(sort: ['name desc']) }

      it 'returns a sort error' do
        result = contract.call(params)

        expect(result).to be_failure
        expect(result.errors.to_hash).to include(:sort)
      end
    end

    context 'without a query' do
      let(:params) { super().except(:query) }

      it 'returns a query error' do
        result = contract.call(params)

        expect(result).to be_failure
        expect(result.errors.to_hash).to include(:query)
      end
    end

    context 'with an invalid page' do
      let(:params) { super().merge(page: 'invalid') }

      it 'returns a page error' do
        result = contract.call(params)

        expect(result).to be_failure
        expect(result.errors.to_hash).to include(:page)
      end
    end
  end
end
