# frozen_string_literal: true

require 'swagger_helper'

RSpec.describe ThreatsController do
  path '/v1/threats/historical' do
    get('threat history') do
      tags 'Threats'
      security [{ ApiKeyAuth: [] }]
      parameter name: :page, in: :query, type: :integer, description: 'pagination'
      parameter name: :per_page, in: :query, type: :integer, description: 'pagination'
      response(200, 'successful') do
        let(:page) { 1 }
        let(:per_page) { 1 }
        let(:threat) do
          create(
            :threat,
            name: "Bestafera",
            rank: "tiger",
            lat: "53.61313754515246",
            lng: "-2.210253950317148",
            status: 2
          )
        end
        let(:hero) do
          create(
            :hero,
            name: "Hang Kreiger Esq.",
            rank: "b",
            lat: "43.89665042937807",
            lng: "-141.4968175370597"
          )
        end
        let(:battle) do
          create(
            :battle,
            hero_id: hero.id,
            threat_id: threat.id,
            score: 71,
            finished_at: 10.seconds.from_now
          )
        end

        let(:expected_body) do
          [
            {
              name: be_a(String),
              rank: be_a(String),
              lat: be_a(String),
              lng: be_a(String),
              battle: {
                heroes: [
                  {
                    name: be_a(String),
                    rank: be_a(String),
                    lat: be_a(String),
                    lng: be_a(String)
                  }
                ],
                score: be_a(Integer),
                duration: have_key(:seconds)
              }
            }
          ]
        end

        before do
          battle
        end

        run_test! do |response|
          expect(response).to have_http_status(:ok)
          expect(parsed_body).to match(expected_body)
        end
      end
    end
  end
end
