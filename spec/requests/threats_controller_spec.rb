# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Threats API' do
  describe 'GET /v1/threats/historical' do
    context 'with valid params' do
      let(:threat) do
        create(:threat, :threats_history, name: 'Dragon', rank: :dragon, status: :disabled, lat: 1.5, lng: -2.5)
      end
      let(:hero) { create(:hero, :threats_history, name: 'Superman', rank: :s) }

      before do
        create(:battle, :threats_history, threat: threat, hero: hero, score: 90, finished_at: 1.minute.from_now)
        get '/v1/threats/historical', params: { page: 1, per_page: 25 }
      end

      it 'returns the threat history' do
        expect(response).to have_http_status(:ok)
        expect(parsed_body.size).to eq(1)
        expect(parsed_body.first).to include(id: threat.id, name: 'Dragon', rank: 'dragon')
        expect(parsed_body.first[:battle]).to include(score: 90)
        expect(parsed_body.first[:battle][:heroes]).to include(include(name: 'Superman', rank: 's'))
      end
    end

    context 'when the threat has no battle' do
      let(:threat) do
        create(:threat, :threats_history, name: 'Lone Threat', rank: :wolf, status: :disabled)
      end

      before do
        threat
        get '/v1/threats/historical', params: { page: 1 }
      end

      it 'serializes the threat without raising' do
        expect(response).to have_http_status(:ok)
        expect(parsed_body.first[:battle]).to include(score: nil, duration: nil, finished_at: nil)
      end
    end

    context 'with an invalid page' do
      before { get '/v1/threats/historical', params: { page: 'invalid' } }

      it 'returns unprocessable entity' do
        expect(response).to have_http_status(:unprocessable_content)
        expect(parsed_body).to include(:page)
      end
    end
  end

  describe 'POST /v1/threats/set_insurgency' do
    before do
      allow(Rails.cache).to receive(:write)
      post '/v1/threats/set_insurgency', params: { insurgency: '5' }
    end

    it 'stores the insurgency time in the cache' do
      expect(response).to have_http_status(:ok)
      expect(Rails.cache).to have_received(:write).with('INSURGENCY_TIME', 5000, raw: true, expires_in: nil)
    end
  end
end
