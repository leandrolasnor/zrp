# frozen_string_literal: true

require 'rails_helper'
RSpec.describe CreateHero::Steps::Create do
  describe '.call' do
    let(:call) { subject.(params) }
    let(:params) do
      {
        name: 'Hero',
        rank: 0,
        lat: 123.90,
        lng: -89.999233
      }
    end

    context 'on Success' do
      before do
        allow(subject).
          to receive(:publish)
          .with('hero.created', hash_including(:hero))
        call
      end

      it 'must be able to create a hero' do
        expect(subject).
          to have_received(:publish)
          .with('hero.created', hash_including(:hero))
        expect(call.name).to eq('Hero')
        expect(call.rank).to eq('c')
        expect(call.lat).to eq(123.90)
        expect(call.lng).to eq(-89.999233)
      end
    end
  end
end
