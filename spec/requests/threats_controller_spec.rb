# frozen_string_literal: true

require 'swagger_helper'

RSpec.describe ThreatsController do
  path '/v1/threats/historical' do
    get('threat history') do
      tags 'Threats'
      parameter name: :page, in: :query, type: :integer, description: 'pagination'
      parameter name: :per_page, in: :query, type: :integer, description: 'pagination'
      response(200, 'successful') do
        schema type: :array, items: {
          type: :object,
          properties: {
            id: { type: :numeric },
            name: { type: :string },
            rank: { type: :string },
            lat: { type: :string },
            lng: { type: :string },
            battle: {
              type: :object, properties: {
                heroes: {
                  type: :array, items: {
                    type: :object, properties: {
                      name: { type: :string },
                      rank: { type: :string },
                      lat: { type: :string },
                      lng: { type: :string }
                    }, required: %w[name rank lat lng]
                  }
                },
                score: { type: :numeric },
                duration: {
                  type: :object, properties: {
                    seconds: { type: :numeric },
                    minutes: { type: :numeric },
                    hours: { type: :numeric }
                  }, required: [:seconds]
                },
                finished_at: { type: :string },
                created_at: { type: :string }
              }, required: %w[heroes score duration finished_at created_at]
            }
          }, required: %w[id name rank lat lng battle]
        }
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

        before do
          battle
          submit_request(_1.metadata)
        end

        run_test!
      end
    end
  end
end
