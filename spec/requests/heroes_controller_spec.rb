# frozen_string_literal: true

require 'swagger_helper'

RSpec.describe HeroesController do
  path '/v1/heroes/list' do
    get('list heroes') do
      tags 'Heroes'
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
              name: heroes[2].name,
              rank: heroes[2].rank,
              lat: heroes[2].lat.to_s,
              lng: heroes[2].lng.to_s
            },
            {
              id: be_a(Integer),
              name: heroes[1].name,
              rank: heroes[1].rank,
              lat: heroes[1].lat.to_s,
              lng: heroes[1].lng.to_s
            },
            {
              id: be_a(Integer),
              name: heroes[0].name,
              rank: heroes[0].rank,
              lat: heroes[0].lat.to_s,
              lng: heroes[0].lng.to_s
            }
          ]
        end

        before do
          heroes
        end

        run_test! do |response|
          expect(response).to have_http_status(:ok)
          expect(parsed_body).to match(expected_body)
        end
      end
    end
  end

  path '/v1/heroes' do
    post('create hero') do
      tags 'Heroes'

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

        run_test! do |response|
          expect(response).to have_http_status(:created)
          expect(parsed_body).to match(expected_body)
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

        run_test! do |response|
          expect(response).to have_http_status(:ok)
          expect(parsed_body).to eq(expected_body)
        end
      end
    end

    patch('update hero') do
      tags 'Heroes'

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

        run_test! do |response|
          expect(response).to have_http_status(:ok)
          expect(parsed_body).to match(expected_body)
        end
      end
    end

    put('update hero') do
      tags 'Heroes'

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

        run_test! do |response|
          expect(response).to have_http_status(:ok)
          expect(parsed_body).to match(expected_body)
        end
      end
    end

    delete('destroy hero') do
      tags 'Heroes'

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

        run_test! do |response|
          expect(response).to have_http_status(:ok)
          expect(parsed_body).to match(expected_body)
        end
      end
    end
  end
end
