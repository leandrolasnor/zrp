# frozen_string_literal: true

require 'swagger_helper'
require 'webmock/rspec'

RSpec.describe MetricsController do
  path '/v1/metrics/dashboard' do
    get('dashboard metric') do
      tags 'Metrics'
      response(200, 'successful') do
        let(:url) { 'fake.com/stream' }

        context 'on Success' do
          run_test! do |response|
            expect(response).to have_http_status(:ok)
            expect(response.headers['Content-Type']).to eq('text/event-stream')

            events = []
            response.body.each_line do |line|
              next unless line.start_with?('data:')

              events << JSON.parse(line.sub(/^data: /, '').strip) rescue next
            end

            expect(events).not_to be_empty
            expect(events).to include(have_key('type'))
            expect(events).to include(have_key('payload'))
          end
        end
      end
    end
  end
end
