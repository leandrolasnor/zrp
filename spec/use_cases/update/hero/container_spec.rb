# frozen_string_literal: true

require 'rails_helper'
RSpec.describe Update::Hero::Container do
  describe 'steps.validate.call' do
    let(:call) { described_class['steps.validate'].(params) }

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

  describe 'steps.update.call' do
    let(:updated) { described_class['steps.update'].(record: hero, **params) }
    let(:hero) do
      create(
        :hero,
        :create_hero,
        name: ' Hero Name',
        rank: 0,
        status: 0
      )
    end

    context 'on Success' do
      let(:params) do
        {
          id: hero.id,
          name: 'Other hero name',
          rank: 1,
          status: 2
        }
      end

      it 'must be able to update hero' do
        expect(updated.name).to eq('Other hero name')
        expect(updated.rank).to eq('b')
        expect(updated.status).to eq('working')
        expect(updated.id).to eq(hero.id)
      end
    end
  end
end
