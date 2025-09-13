# frozen_string_literal: true

require 'rails_helper'
RSpec.describe Create::Hero::Container do
  describe 'steps.validate.call' do
    let(:call) { described_class['steps.validate'].(params) }

    context 'on Success' do
      let(:params) do
        {
          name: 'Hero',
          rank: 'c',
          lat: 123.90,
          lng: -89.345
        }
      end

      it 'must be able to validate hero params' do
        expect(call).to be_success
      end
    end

    context 'on Failure' do
      let(:params) do
        {
          name: 1,
          rank: 'p',
          lat: 'hero',
          lng: 'rank'
        }
      end
      let(:expected_errors) do
        {
          name: ['must be a string'],
          rank: ['must be one of: c, b, a, s'],
          lat: ['must be a float'],
          lng: ['must be a float']
        }
      end

      it 'must be able to get errors from contract' do
        expect(call).to be_failure
        expect(call.failure.errors.to_h).to match(expected_errors)
      end
    end
  end

  describe 'steps.persist.call' do
    let(:call) { described_class['steps.persist'].(params) }
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
