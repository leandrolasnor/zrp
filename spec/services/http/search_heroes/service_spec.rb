# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Http::SearchHeroes::Service do
  describe '.call' do
    subject(:call) { described_class.call(params) }

    let(:params) do
      {
        query: 'hero',
        filter: ["rank = 's'"],
        page: '1',
        per_page: '10',
        sort: ['name:asc']
      }
    end

    context 'on Success' do
      let(:result) { { 'hits' => [{ 'name' => 'Superman' }], 'totalHits' => 1 } }
      let(:monad) { instance_double(SearchHeroes::Monad, call: Dry::Monads::Success(result)) }

      before { allow(SearchHeroes::Monad).to receive(:new).and_return(monad) }

      it 'returns ok with the search result' do
        expect(call).to eq([:ok, result])
      end
    end

    context 'on Failure' do
      let(:error) { StandardError.new('search failed') }
      let(:monad) do
        instance_double(SearchHeroes::Monad, call: Dry::Monads::Try::Error.new(error))
      end

      before do
        allow(SearchHeroes::Monad).to receive(:new).and_return(monad)
        allow(Rails.logger).to receive(:error)
      end

      it 'logs the monad exception and returns internal_server_error' do
        expect(call).to eq([:internal_server_error])
        expect(Rails.logger).to have_received(:error).with(error)
      end
    end

    context 'with invalid params' do
      let(:params) { super().merge(filter: ['invalid filter']) }

      before { allow(SearchHeroes::Monad).to receive(:new) }

      it 'applies the contract and returns unprocessable_entity' do
        status, errors = call

        expect(status).to eq(:unprocessable_entity)
        expect(errors).to include(:filter)
        expect(SearchHeroes::Monad).not_to have_received(:new)
      end
    end
  end
end
