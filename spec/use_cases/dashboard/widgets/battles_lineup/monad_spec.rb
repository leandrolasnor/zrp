# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Dashboard::Widgets::BattlesLineup::Monad do
  describe '.call' do
    subject(:monad) { described_class.new(model: model) }

    let(:model) { double }
    let(:search) do
      {
        'totalHits' => 5,
        'facetDistribution' => { 'lineup' => { '1' => 2, '2' => 3 } }
      }
    end

    before { allow(model).to receive(:ms_raw_search).and_return(search) }

    it 'returns the lineup percentages and the real battle count' do
      result = monad.call

      expect(result).to be_success
      expect(result.value!).to eq(lineup: [['One Hero', 40], ['Two Heroes', 60]], count: 5)
    end

    context 'when no battles were found' do
      let(:search) { { 'totalHits' => 0, 'facetDistribution' => { 'lineup' => {} } } }

      it 'returns zero percentages and a zero count' do
        result = monad.call

        expect(result).to be_success
        expect(result.value!).to eq(lineup: [['One Hero', 0], ['Two Heroes', 0]], count: 0)
      end
    end

    context 'when the search fails' do
      before { allow(model).to receive(:ms_raw_search).and_raise(StandardError, 'search failed') }

      it { expect(monad.call).to be_failure }
    end
  end
end
