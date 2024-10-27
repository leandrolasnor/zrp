# frozen_string_literal: true

require 'rails_helper'
RSpec.describe SearchHeroes::Monad do
  let(:call) do
    subject.(
      query: query,
      page: page,
      per_page: per_page,
      sort: sort,
      filter: filter
    )
  end

  describe '.call' do
    let(:query) { 'oi' }
    let(:page) { 1 }
    let(:per_page) { 2 }
    let(:sort) { 'name:asc' }
    let(:filter) { [] }

    before do
      allow(SearchHeroes::Model::Hero)
        .to receive(:ms_raw_search)
        .with(
          query,
          filter: [],
          page: page,
          hits_per_page: per_page,
          sort: [sort]
        )
      call
    end

    it 'must be able to call search method' do
      expect(SearchHeroes::Model::Hero).
        to have_received(:ms_raw_search).
        with(
          query,
          filter: [],
          page: page,
          hits_per_page: per_page,
          sort: [sort]
        )
    end
  end
end
