# frozen_string_literal: true

require 'rails_helper'
RSpec.describe AlertReceives::UN::Transaction do
  describe '.call' do
    let(:call) { described_class.new.call params }

    context 'with wrong params' do
      let(:params) { {} }
      let(:expected_errors) do
        {
          monsterName: ["is missing"],
          dangerLevel: ["is missing"],
          location: ["is missing"]
        }
      end

      it 'must be able to get a failure' do
        expect(call).to be_failure
        expect(call.failure.errors.to_hash).to match(expected_errors)
      end
    end

    context 'with correct params' do
      let(:params) do
        {
          monsterName: 'Monster Name',
          dangerLevel: 'Tiger',
          location: {
            lng: 123.123,
            lat: -90.89
          }
        }
      end

      let(:expected_attributes) do
        {
          id: be_a(Integer),
          name: 'Monster Name',
          rank: 'tiger',
          status: 'enabled',
          lat: -0.9089e2,
          lng: 0.123123e3,
          payload: "{\"monsterName\":\"Monster Name\",\"dangerLevel\":\"Tiger\",\"location\":{\"lat\":-90.89,\"lng\":123.123}}",
          created_at: be_a(Time),
          updated_at: be_a(Time)
        }
      end

      it 'must be able to persist a threat params with enabled status' do
        expect(call).to be_success
        expect(call.value!).to be_a(AlertReceives::UN::Model::Threat)
        expect(call.value!.attributes.symbolize_keys).to match(expected_attributes)
      end
    end
  end
end
