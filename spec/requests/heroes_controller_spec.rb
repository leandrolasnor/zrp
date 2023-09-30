# frozen_string_literal: true

require 'swagger_helper'

RSpec.describe HeroesController do
  path '/v1/heroes/list' do
    get('list heroes') do
      tags 'Heroes'
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
              lat: heroes[3].lat.to_s,
              lng: heroes[3].lng.to_s
            },
            {
              id: be_a(Integer),
              name: heroes[4].name,
              rank: heroes[4].rank,
              lat: heroes[4].lat.to_s,
              lng: heroes[4].lng.to_s
            },
            {
              id: be_a(Integer),
              name: heroes[5].name,
              rank: heroes[5].rank,
              lat: heroes[5].lat.to_s,
              lng: heroes[5].lng.to_s
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
      tags 'Heroes'
      security [{ ApiKeyAuth: [] }]
      consumes "application/json"
      parameter name: :params, in: :body, schema: {
        type: :object,
        properties: {
          name: { type: :string },
          rank: { type: :integer },
          lat: { type: :number },
          lng: { type: :number }
        },
        required: [:name, :rank, :lat, :lng]
      }
      response(201, 'successful') do
        let(:lat) { -47.3602244101421 }
        let(:lng) { 42.35626747005944 }
        let(:params) do
          {
            name: 'Heroizinho',
            rank: 0,
            lat: lat,
            lng: lng
          }
        end

        let(:expected_body) do
          {
            id: be_a(Integer),
            name: 'Heroizinho',
            rank: 'c',
            lat: lat.to_s,
            lng: lng.to_s
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
    let(:hero) { create(:hero, name: 'Hero name', rank: 2, lat: lat, lng: lng) }
    let(:lat) { -1.691468683929372 }
    let(:lng) { -90.9745256083916 }
    parameter name: 'id', in: :path, type: :string, required: true

    get('show hero') do
      tags 'Heroes'
      consumes "application/json"
      produces 'application/json'
      security [{ ApiKeyAuth: [] }]
      response(200, 'successful') do
        let(:id) { hero.id }
        let(:expected_body) do
          {
            name: 'Hero name',
            rank: 'a',
            lat: lat.to_s,
            lng: lng.to_s
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
      tags 'Heroes'
      security [{ ApiKeyAuth: [] }]
      consumes "application/json"
      parameter name: :params, in: :body, schema: {
        type: :object,
        properties: {
          name: { type: :string },
          lat: { type: :numeric },
          lng: { type: :numeric }
        },
        required: [:name, :lat, :lng]
      }

      response(200, 'successful') do
        let(:id) { hero.id }
        let(:lat) { 5.529871874122506 }
        let(:lng) { -162.4156876628909 }

        let(:params) do
          {
            name: 'Other name for hero',
            lat: lat,
            lng: lng
          }
        end

        let(:expected_body) do
          {
            name: 'Other name for hero',
            rank: 'a',
            lat: lat.to_s,
            lng: lng.to_s
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
      tags 'Heroes'
      security [{ ApiKeyAuth: [] }]
      consumes "application/json"
      parameter name: :params, in: :body, schema: {
        type: :object,
        properties: {
          name: { type: :string },
          rank: { type: :integer },
          lat: { type: :numeric },
          lng: { type: :numeric }
        },
        required: [:name, :rank, :lat, :lng]
      }
      response(200, 'successful') do
        let(:id) { hero.id }
        let(:lat) { -22.86210918520104 }
        let(:lng) { -27.26000247930017 }

        let(:params) do
          {
            name: 'Ramon Valdez',
            rank: 3,
            lat: lat,
            lng: lng
          }
        end

        let(:expected_body) do
          {
            name: 'Ramon Valdez',
            rank: 's',
            lat: lat.to_s,
            lng: lng.to_s
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

    delete('destroy hero') do
      tags 'Heroes'
      security [{ ApiKeyAuth: [] }]
      consumes "application/json"
      response(200, 'successful') do
        let(:id) { hero.id }

        let(:expected_body) do
          {
            id: be_a(Integer),
            name: 'Hero name',
            rank: 'a',
            lat: be_a(String),
            lng: be_a(String)
          }
        end

        context 'on Success' do
          run_test!
          it 'must be able to destroy hero' do
            expect(response).to have_http_status(:ok)
            expect(parsed_body).to match(expected_body)
          end
        end
      end
    end
  end
end
