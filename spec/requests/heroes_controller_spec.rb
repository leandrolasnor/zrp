# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Heroes API' do
  describe 'GET /v1/heroes/:id' do
    context 'when the hero exists' do
      let(:hero) { create(:hero, :create_hero, name: 'Superman', rank: :s, lat: 1.5, lng: -2.5) }

      before { get "/v1/heroes/#{hero.id}" }

      it 'returns the hero' do
        expect(response).to have_http_status(:ok)
        expect(parsed_body).to include(name: 'Superman', rank: 's')
      end
    end

    context 'when the hero does not exist' do
      before { get '/v1/heroes/0' }

      it 'returns not found' do
        expect(response).to have_http_status(:not_found)
      end
    end
  end

  describe 'POST /v1/heroes' do
    let(:params) do
      {
        hero: {
          name: 'Batman',
          rank: 'a',
          lat: 10.5,
          lng: 20.5
        }
      }
    end

    context 'with valid params' do
      before { post '/v1/heroes', params: params, as: :json }

      it 'creates the hero' do
        expect(response).to have_http_status(:created)
        expect(parsed_body).to include(name: 'Batman', rank: 'a', status: 'enabled')
      end
    end

    context 'with invalid params' do
      let(:params) { { hero: { name: 'Batman', rank: 'invalid', lat: 10.5, lng: 20.5 } } }

      before { post '/v1/heroes', params: params, as: :json }

      it 'returns unprocessable entity' do
        expect(response).to have_http_status(:unprocessable_content)
        expect(parsed_body).to include(:rank)
      end
    end
  end

  describe 'PATCH /v1/heroes/:id' do
    let(:hero) { create(:hero, :create_hero, name: 'Batman', rank: :c, lat: 0, lng: 0) }
    let(:params) do
      {
        hero: {
          id: hero.id,
          name: 'Nightwing',
          rank: 'a',
          lat: 10.5,
          lng: 20.5
        }
      }
    end

    context 'with valid params' do
      before { patch "/v1/heroes/#{hero.id}", params: params, as: :json }

      it 'updates the hero' do
        expect(response).to have_http_status(:ok)
        expect(parsed_body).to include(name: 'Nightwing', rank: 'a')
      end
    end

    context 'with invalid params' do
      let(:params) { { hero: { id: hero.id, rank: 'invalid' } } }

      before { patch "/v1/heroes/#{hero.id}", params: params, as: :json }

      it 'returns unprocessable entity' do
        expect(response).to have_http_status(:unprocessable_content)
        expect(parsed_body).to include(:rank)
      end
    end
  end

  describe 'DELETE /v1/heroes/:id' do
    context 'with a valid id' do
      let(:hero) { create(:hero, :delete_hero, name: 'Aquaman', rank: :b) }

      before { delete "/v1/heroes/#{hero.id}" }

      it 'destroys the hero' do
        expect(response).to have_http_status(:ok)
        expect(parsed_body).to include(id: hero.id, name: 'Aquaman', rank: 'b')
        expect(hero.reload.deleted_at).to be_present
      end
    end

    context 'with a non-integer id' do
      before { delete '/v1/heroes/not-an-integer' }

      it 'returns unprocessable entity' do
        expect(response).to have_http_status(:unprocessable_content)
        expect(parsed_body).to include(:id)
      end
    end
  end

  describe 'GET /v1/heroes/search' do
    let(:params) do
      {
        query: 'Superman',
        page: 1,
        per_page: 10,
        filter: ["rank = 's'"],
        sort: ['name:asc']
      }
    end

    context 'with valid params' do
      let(:search_result) { { hits: [{ name: 'Superman' }], totalHits: 1 } }

      before do
        allow(SearchHeroes::Model::Hero).to receive(:ms_raw_search).and_return(search_result)
        get '/v1/heroes/search', params: params
      end

      it 'returns the search result' do
        expect(response).to have_http_status(:ok)
        expect(parsed_body).to eq(search_result)
        expect(SearchHeroes::Model::Hero).to have_received(:ms_raw_search).with(
          'Superman',
          filter: ["rank = 's'"],
          page: 1,
          hits_per_page: 10,
          sort: ['name:asc']
        )
      end
    end

    context 'without a filter' do
      let(:params) { super().except(:filter) }
      let(:search_result) { { hits: [{ name: 'Superman' }], totalHits: 1 } }

      before do
        allow(SearchHeroes::Model::Hero).to receive(:ms_raw_search).and_return(search_result)
        get '/v1/heroes/search', params: params
      end

      it 'searches with an empty filter' do
        expect(response).to have_http_status(:ok)
        expect(SearchHeroes::Model::Hero).to have_received(:ms_raw_search).with(
          'Superman',
          filter: [],
          page: 1,
          hits_per_page: 10,
          sort: ['name:asc']
        )
      end
    end

    context 'with an invalid filter' do
      let(:params) { super().merge(filter: ['invalid filter']) }

      before do
        allow(SearchHeroes::Model::Hero).to receive(:ms_raw_search)
        get '/v1/heroes/search', params: params
      end

      it 'returns unprocessable entity without searching' do
        expect(response).to have_http_status(:unprocessable_content)
        expect(parsed_body).to include(:filter)
        expect(SearchHeroes::Model::Hero).not_to have_received(:ms_raw_search)
      end
    end

    context 'with an invalid sort' do
      let(:params) { super().merge(sort: ['name desc']) }

      before do
        allow(SearchHeroes::Model::Hero).to receive(:ms_raw_search)
        get '/v1/heroes/search', params: params
      end

      it 'returns unprocessable entity without searching' do
        expect(response).to have_http_status(:unprocessable_content)
        expect(parsed_body).to include(:sort)
        expect(SearchHeroes::Model::Hero).not_to have_received(:ms_raw_search)
      end
    end

    context 'without a query' do
      let(:params) { super().except(:query) }

      before { get '/v1/heroes/search', params: params }

      it 'returns unprocessable entity' do
        expect(response).to have_http_status(:unprocessable_content)
        expect(parsed_body).to include(:query)
      end
    end

    context 'with an invalid page' do
      let(:params) { super().merge(page: 'invalid') }

      before { get '/v1/heroes/search', params: params }

      it 'returns unprocessable entity' do
        expect(response).to have_http_status(:unprocessable_content)
        expect(parsed_body).to include(:page)
      end
    end
  end

  describe 'GET /v1/heroes/ranks' do
    before { get '/v1/heroes/ranks' }

    it 'returns the hero ranks' do
      expect(response).to have_http_status(:ok)
      expect(parsed_body).to eq(%w[c b a s])
    end
  end

  describe 'GET /v1/heroes/statuses' do
    before { get '/v1/heroes/statuses' }

    it 'returns the hero statuses' do
      expect(response).to have_http_status(:ok)
      expect(parsed_body).to eq(%w[disabled enabled working])
    end
  end
end
