# frozen_string_literal: true

require 'swagger_helper'
require 'webmock/rspec'

RSpec.describe MetricsController do
  path '/v1/metrics/dashboard' do
    get('dashboard metric') do
      tags 'Metrics'
      security [{ ApiKeyAuth: [] }]
      response(200, 'successful') do
        let(:heroes) { create_list(:hero, 5, :dashboard) }
        let(:threats) { create_list(:threat, 7, :dashboard) }
        let(:url) { 'fake.com/stream' }
        let(:client) { SSE::EventSource.new(url) }
        let(:expected_body) do
          {
            data: {
              type: 'METRICS_FETCHED',
              payload: []
            }
          }
        end

        before do
          heroes.first.working!
          heroes.second.working!

          threats.first.disabled!
          threats.second.disabled!
          threats.third.problem!
        end

        context 'on Success' do
          run_test!
          it 'must be able to get events' do
            WebMock.stub_request(:get, url).to_return(
              body: response.body,
              headers: response.headers
            )
            events = []
            es = SSE::EventSource.new(url)
            es.message do |event|
              events << JSON.parse(event)
            end
            es.start

            expect(response).to have_http_status(:ok)
            expect(response.headers['Content-Type']).to eq('text/event-stream')
            expect(events.count).to eq(5)
            expect(events.first['payload'].keys.first).to eq('threat_count')
            expect(events.second['payload'].keys.first).to eq('hero_count')
            expect(events.third['payload'].keys.first).to eq('threats_grouped')
            expect(events.fourth['payload'].keys.first).to eq('heroes_grouped')
            expect(events.fifth['payload'].keys.first).to eq('average_score')
          end
        end
      end
    end
  end
end
