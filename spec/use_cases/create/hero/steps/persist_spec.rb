# frozen_string_literal: true

require 'rails_helper'
RSpec.describe Create::Hero::Steps::Persist do
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
      before { call }

      it 'must be able to create a hero' do
        expect(call.name).to eq('Hero')
        expect(call.rank).to eq('c')
        expect(call.lat).to eq(123.90)
        expect(call.lng).to eq(-89.999233)
      end
    end
  end
end
