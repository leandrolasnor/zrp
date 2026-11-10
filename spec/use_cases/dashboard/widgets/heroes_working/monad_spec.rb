# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Dashboard::Widgets::HeroesWorking::Monad do
  describe '.call' do
    subject(:monad) { described_class.new(model: model) }

    let(:model) { double }
    let(:idle) do
      {
        'totalHits' => 10,
        'facetDistribution' => { 'rank' => { 's' => 2, 'a' => 3, 'b' => 4, 'c' => 1 } }
      }
    end
    let(:working) do
      {
        'totalHits' => 5,
        'facetDistribution' => { 'rank' => { 's' => 1, 'a' => 2 } }
      }
    end

    before do
      allow(model).to receive(:ms_raw_search)
        .with('', page: 0, facets: [:rank], filter: ['status != disabled'])
        .and_return(idle)
      allow(model).to receive(:ms_raw_search)
        .with('', page: 0, facets: [:rank], filter: ['status = working'])
        .and_return(working)
    end

    it 'builds the rank distribution metrics' do
      result = monad.call

      expect(result).to be_success
      expect(result.value!).to eq(global: 50, s: 50, a: 67, b: 0, c: 0, count: 5)
    end

    context 'when the search fails' do
      before { allow(model).to receive(:ms_raw_search).and_raise(StandardError, 'search failed') }

      it { expect(monad.call).to be_failure }
    end
  end
end
