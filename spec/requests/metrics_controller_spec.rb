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
            expect(events.count).to eq(10)
            expect(events.first['payload'].keys.first).to eq('threat_count')
            expect(events.second['payload'].keys.first).to eq('battle_count')
            expect(events.third['payload'].keys.first).to eq('hero_count')
            expect(events.fourth['payload'].keys.first).to eq('threats_grouped_rank_status')
            expect(events.fifth['payload'].keys.first).to eq('threats_grouped_rank')
            expect(events[5]['payload'].keys.first).to eq('heroes_grouped_rank_status')
            expect(events[6]['payload'].keys.first).to eq('heroes_grouped_rank')
            expect(events[7]['payload'].keys.first).to eq('average_score')
            expect(events[8]['payload'].keys.first).to eq('battles_two_and_one_percent')
            expect(events[9]['payload'].keys.first).to eq('average_time_to_match')
          end
        end
      end
    end
  end
end
