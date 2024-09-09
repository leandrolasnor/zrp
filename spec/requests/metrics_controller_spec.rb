# frozen_string_literal: true

require 'swagger_helper'
require 'webmock/rspec'

RSpec.describe MetricsController do
  path '/v1/metrics/dashboard' do
    get('dashboard metric') do
      tags 'Metrics'
      response(200, 'successful') do
        let(:heroes) { create_list(:hero, 5, :dashboard) }
        let(:threats) { create_list(:threat, 7, :dashboard) }
        let(:url) { 'fake.com/stream' }
        let(:client) { SSE::EventSource.new(url) }

        before do
          heroes.first.working!
          heroes.second.working!
          create(:battle, score: 80, hero_id: heroes.first.id, threat_id: threats.first.id,
                          finished_at: 5.seconds.from_now)
          create(:battle, score: 74, hero_id: heroes.second.id, threat_id: threats.second.id,
                          finished_at: 5.seconds.from_now)
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
            expect(events).to include(have_key('type'))
            expect(events).to include(have_key('payload'))
          end
        end
      end
    end
  end
end
