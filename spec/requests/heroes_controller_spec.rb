# frozen_string_literal: true

require 'swagger_helper'

RSpec.describe HeroesController do
  path '/v1/heroes/list' do
    get('list heroes') do
      security [{ ApiKeyAuth: [] }]
      parameter name: :page, in: :query, type: :integer, description: 'pagination'
      parameter name: :per_page, in: :query, type: :integer, description: 'pagination'
      response(200, 'successful') do
        let(:heroes) { create_list(:hero, 6) }
        let(:page) { 2 }
        let(:per_page) { 3 }

        let(:expected_body) do
          [
            {
              id: be_a(Integer),
              name: heroes[3].name,
              rank: heroes[3].rank,
              lat: heroes[3].lat,
              lng: heroes[3].lng
            },
            {
              id: be_a(Integer),
              name: heroes[4].name,
              rank: heroes[4].rank,
              lat: heroes[4].lat,
              lng: heroes[4].lng
            },
            {
              id: be_a(Integer),
              name: heroes[5].name,
              rank: heroes[5].rank,
              lat: heroes[5].lat,
              lng: heroes[5].lng
            }
          ]
        end

        before { heroes }

        context 'on Success' do
          run_test!
          it 'must be able to get the second page of heros list' do
            expect(response).to have_http_status(:ok)
            expect(parsed_body).to match(expected_body)
          end
        end
      end
    end
  end

  path '/v1/heroes' do
    post('create hero') do
      security [{ ApiKeyAuth: [] }]
      consumes "application/json"
      parameter name: :params, in: :body, schema: {
        type: :object,
        properties: {
          name: { type: :string },
          rank: { type: :integer },
          lat: { type: :float },
          lng: { type: :float }
        },
        required: [:name, :rank, :lat, :lng]
      }
      response(201, 'successful') do
        let(:params) do
          {
            name: 'Heroizinho',
            rank: 0,
            lat: -17.227,
            lng: 71.007
          }
        end

        let(:expected_body) do
          {
            id: be_a(Integer),
            name: 'Heroizinho',
            rank: 's',
            lat: -17.227,
            lng: 71.007
          }
        end

        context 'on Success' do
          run_test!
          it 'must be able to create a hero' do
            expect(response).to have_http_status(:created)
            expect(parsed_body).to match(expected_body)
          end
        end
      end
    end
  end

  path '/v1/heroes/{id}' do
    let(:hero) { create(:hero, name: 'Hero name', rank: 2, lat: -12.897, lng: 88.907) }
    parameter name: 'id', in: :path, type: :string, required: true

    get('show hero') do
      security [{ ApiKeyAuth: [] }]
      response(200, 'successful') do
        let(:id) { hero.id }
        let(:expected_body) do
          {
            name: 'Hero name',
            rank: 2,
            lat: -12.897,
            lng: 88.907
          }
        end

        context 'on Success' do
          run_test!
          it 'must be able to get a heros record' do
            expect(response).to have_http_status(:ok)
            expect(parsed_body).to eq(expected_body)
          end
        end
      end
    end

    patch('update hero') do
      security [{ ApiKeyAuth: [] }]
      consumes "application/json"
      parameter name: :params, in: :body, schema: {
        type: :object,
        properties: {
          name: { type: :string },
          lat: { type: :float },
          lng: { type: :float }
        },
        required: [:name, :lat, :lng]
      }

      response(200, 'successful') do
        let(:id) { hero.id }

        let(:params) do
          {
            name: 'Other name for hero',
            lat: 123.898,
            lng: -33.754
          }
        end

        let(:expected_body) do
          {
            name: 'Other name for hero',
            rank: 'b',
            lat: 123.898,
            lng: -33.754
          }
        end

        context 'on Success' do
          run_test!
          it 'must be able to update some data from hero' do
            expect(response).to have_http_status(:ok)
            expect(parsed_body).to eq(expected_body)
          end
        end
      end
    end

    put('update hero') do
      security [{ ApiKeyAuth: [] }]
      consumes "application/json"
      parameter name: :params, in: :body, schema: {
        type: :object,
        properties: {
          name: { type: :string },
          rank: { type: :integer },
          lat: { type: :float },
          lng: { type: :float }
        },
        required: [:name, :rank, :lat, :lng]
      }
      response(200, 'successful') do
        let(:id) { hero.id }

        let(:params) do
          {
            name: 'Ramon Valdez',
            rank: 3,
            lat: 34.808,
            lng: -29.707
          }
        end

        let(:expected_body) do
          {
            name: 'Ramon Valdez',
            rank: 'c',
            lat: 34.808,
            lng: -29.707
          }
        end

        context 'on Success' do
          run_test!
          it 'must be able to update hero' do
            expect(response).to have_http_status(:ok)
            expect(parsed_body).to eq(expected_body)
          end
        end
      end
    end
  end
end
