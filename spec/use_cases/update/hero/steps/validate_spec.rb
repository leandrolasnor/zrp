# frozen_string_literal: true

require 'rails_helper'
RSpec.describe Update::Hero::Steps::Validate do
  describe '.call' do
    let(:call) { subject.(params) }

    context 'on Success' do
      let(:params) do
        {
          id: 0,
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
          id: 'uuid',
          name: 1,
          rank: 't',
          lat: 'hero',
          lng: 'rank'
        }
      end
      let(:expected_errors) do
        {
          id: ['must be an integer'],
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
end
