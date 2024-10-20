# frozen_string_literal: true

require 'rails_helper'
RSpec.describe AlertReceives::UN::Transaction do
  describe '.call' do
    let(:res) { described_class.new.call params }

    context 'with wrong params' do
      let(:params) { {} }

      it 'must be able to persist a threat with problem status' do
        expect(res).to be_success
        expect(res.value!).to be_problem
      end
    end

    context 'with correct params' do
      let(:params) do
        {
          monsterName: 'Monster Name',
          dangerLevel: 'tiger',
          location: {
            lng: 123.123,
            lat: -90.89
          }
        }
      end

      let(:expected_record) do
        {
          name: 'Eobard Thawne',
          rank: 'tiger',
          status: 'enabled',
          lat: '70.38704353933477',
          lng: '-42.78322998876705'
        }
      end

      it 'must be able to persist a threat params with enabled status' do
        expect(res).to be_success
        expect(res.value!).to match(expected_record)
      end
    end
  end
end
