# frozen_string_literal: true

require 'rails_helper'
RSpec.describe CreateThreat::Monad do
  describe '#call' do
    context 'on Success' do
      let(:call) { described_class.new.call(params) }
      let(:attributes) { call.value!.attributes.symbolize_keys }

      let(:params) do
        {
          location: [{ lat: 70.38704353933477, lng: -42.78322998876705 }],
          dangerLevel: 'Tiger',
          monsterName: 'Eobard Thawne',
          monster: {
            name: 'Eobard Thawne',
            url: 'https://upload.wikimedia.org/wikipedia/en/8/8e/Reverse-Flash_%28Eobard_Thawne%29.png',
            description: 'Eobard Thawne, otherwise known as the Reverse-Flash and Professor Zoom, is a fictional supervillain appearing in American comic books published by DC Comics. The character was created by John Broome and Carmine Infantino, and first appeared in The Flash #139 in September 1963.'
          }
        }
      end

      let(:expected_record) do
        {
          id: be_a(Integer),
          name: 'Eobard Thawne',
          status: 'enabled',
          rank: 'tiger',
          lat: 0.7038704353933477e2,
          lng: -0.4278322998876705e2,
          payload: params.to_json
        }
      end

      it 'must be able to create a threat' do
        expect(attributes.except(:created_at, :updated_at)).to match(expected_record)
        expect(call.value!).to be_a(CreateThreat::Model::Threat)
      end
    end

    context 'when payload layout is wrong' do
      let(:call) { described_class.new.call(params) }
      let(:attributes) { call.value!.attributes.symbolize_keys }

      let(:params) do
        {
          lat: 70.38704353933477,
          lng: -42.78322998876705,
          rank: 'Tiger',
          name: 'Eobard Thawne',
          monster: {
            name: 'Eobard Thawne',
            url: 'https://upload.wikimedia.org/wikipedia/en/8/8e/Reverse-Flash_%28Eobard_Thawne%29.png',
            description: 'Eobard Thawne, otherwise known as the Reverse-Flash and Professor Zoom, is a fictional supervillain appearing in American comic books published by DC Comics. The character was created by John Broome and Carmine Infantino, and first appeared in The Flash #139 in September 1963.'
          }
        }
      end

      let(:expected_record) do
        {
          id: be_a(Integer),
          name: be_nil,
          status: 'problem',
          rank: be_nil,
          lat: be_nil,
          lng: be_nil,
          payload: params.to_json
        }
      end

      it 'must be able to get a threat with layout problem' do
        expect(attributes.except(:created_at, :updated_at)).to match(expected_record)
        expect(call.value!).to be_a(CreateThreat::Model::Threat)
      end
    end
  end
end
