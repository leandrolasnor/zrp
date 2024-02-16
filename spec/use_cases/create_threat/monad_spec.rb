# frozen_string_literal: true

require 'rails_helper'
RSpec.describe CreateThreat::Monad do
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
          location: [
            {
              lng: 123.123,
              lat: -90.89
            }
          ]
        }
      end

      it 'must be able to persist a threat with enabled status' do
        expect(res).to be_success
        expect(res.value!).to be_enabled
      end
    end
  end
end
