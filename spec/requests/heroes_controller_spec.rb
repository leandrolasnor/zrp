# frozen_string_literal: true

require 'swagger_helper'

RSpec.describe HeroesController do
  path '/v1/heroes/search' do
    get('search heroes') do
      tags 'Heroes'
      parameter name: :query, in: :query, type: :string, description: 'query', example: "Silva"
      parameter name: :page, in: :query, type: :integer, description: 'pagination', example: "1"
      parameter name: :per_page, in: :query, type: :integer, description: 'pagination', example: "3"
      parameter name: :sort, in: :query, type: :string, description: 'sort', required: false, example: "name:desc"
      response(200, 'successful') do
        let(:query) { 'query' }
        let(:page) { 2 }
        let(:per_page) { 3 }
        let(:sort) { 'name:desc' }
        run_test!
      end
    end
  end

  path '/v1/heroes/list' do
    get('list heroes') do
      tags 'Heroes'
      parameter name: :page, in: :query, type: :integer, description: 'pagination', example: '1'
      parameter name: :per_page, in: :query, type: :integer, description: 'pagination', example: '3'
      response(200, 'successful') do
        schema type: :array, items: {
          type: :object,
          properties: {
            id: { type: :integer },
            name: { type: :string },
            rank: { type: :string },
            lat: { type: :string },
            lng: { type: :string }
          }
        }
        let(:heroes) { create_list(:hero, 6) }
        let(:page) { 2 }
        let(:per_page) { heroes.count - 3 }
        run_test!
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
          name: { type: :string, example: 'Forrest Gump' },
          rank: { type: :integer, example: '2' },
          lat: { type: :number, example: -45.8987657787876755 },
          lng: { type: :number, example: 66.898790547877123545 }
        },
        required: [:name, :rank, :lat, :lng]
      }
      response(201, 'successful') do
        schema type: :object, properties: {
          id: { type: :integer },
          name: { type: :string },
          rank: { type: :string },
          lat: { type: :string },
          lng: { type: :string }
        }, required: ['id', 'name', 'rank', 'lat', 'lng']
        let(:params) do
          {
            name: 'Heroizinho',
            rank: 0,
            lat: -47.3602244101421,
            lng: 42.35626747005944
          }
        end
        run_test!
      end
    end
  end

  path '/v1/heroes/{id}' do
    let(:hero) { create(:hero) }
    parameter name: 'id', in: :path, type: :string, required: true
    get('show hero') do
      tags 'Heroes'
      consumes "application/json"
      produces 'application/json'
      response(200, 'successful') do
        let(:id) { hero.id }
        schema type: :object, properties: {
          name: { type: :string },
          rank: { type: :string },
          lat: { type: :string },
          lng: { type: :string }
        }, required: ['name', 'rank', 'lat', 'lng']
        run_test!
      end
    end

    patch('update hero') do
      tags 'Heroes'
      consumes "application/json"
      parameter name: :params, in: :body, schema: {
        type: :object,
        properties: {
          id: { type: :integer, example: '1' },
          name: { type: :string, example: 'Silva' },
          lat: { type: :numeric, example: 5.529871874122506 },
          lng: { type: :numeric, example: -162.4156876628909 }
        },
        required: [:id, :name, :lat, :lng]
      }
      response(200, 'successful') do
        let(:id) { hero.id }
        schema type: :object, properties: {
          name: { type: :string },
          rank: { type: :string },
          lat: { type: :string },
          lng: { type: :string }
        }, required: ['name', 'rank', 'lat', 'lng']
        let(:params) do
          {
            id: hero.id,
            name: 'Other name for hero',
            lat: 5.529871874122506,
            lng: -162.4156876628909
          }
        end
        run_test!
      end
    end

    put('update hero') do
      tags 'Heroes'
      consumes "application/json"
      parameter name: :params, in: :body, schema: {
        type: :object,
        properties: {
          id: { type: :integer, example: '1' },
          name: { type: :string, example: 'Silva' },
          rank: { type: :integer, example: '0' },
          lat: { type: :numeric, example: -22.86210918520104 },
          lng: { type: :numeric, example: -27.26000247930017 }
        },
        required: [:id, :name, :rank, :lat, :lng]
      }
      response(200, 'successful') do
        schema type: :object, properties: {
          name: { type: :string },
          rank: { type: :string },
          lat: { type: :string },
          lng: { type: :string }
        }, required: ['name', 'rank', 'lat', 'lng']
        let(:id) { hero.id }
        let(:params) do
          {
            id: hero.id,
            name: 'Ramon Valdez',
            rank: 3,
            lat: -22.86210918520104,
            lng: -27.26000247930017
          }
        end
        run_test!
      end
    end

    delete('destroy hero') do
      tags 'Heroes'
      consumes "application/json"
      response(200, 'successful') do
        let(:id) { hero.id }
        schema type: :object, properties: {
          id: { type: :integer },
          name: { type: :string },
          rank: { type: :string },
          lat: { type: :string },
          lng: { type: :string }
        }, required: ['name', 'rank', 'lat', 'lng']
        run_test!
      end

      response(422, 'when hero is working') do
        let(:hero) { create(:hero, :create_hero, status: :working) }
        let(:id) { hero.id }
        let(:params) { { id: hero.id } }
        schema type: :string
        run_test!
      end
    end
  end
end
