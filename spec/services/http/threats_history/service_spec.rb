# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Http::ThreatsHistory::Service do
  describe '.call' do
    context 'on Success' do
      let(:threat) do
        create(:threat, :threats_history, status: :disabled)
      end

      before { create(:battle, :threats_history, threat: threat) }

      it 'returns ok with the threats and serializer' do
        status, threats, serializer = described_class.call(page: 1)

        expect(status).to eq(:ok)
        expect(threats).to include(threat)
        expect(serializer).to eq(Http::ThreatsHistory::Serializer)
      end
    end

    context 'on Failure' do
      let(:error) { StandardError.new('history failed') }
      let(:monad) do
        instance_double(ThreatsHistory::Monad, call: Dry::Monads::Try::Error.new(error))
      end

      before do
        allow(ThreatsHistory::Monad).to receive(:new).and_return(monad)
        allow(Rails.logger).to receive(:error)
      end

      it 'logs the error and returns internal_server_error' do
        status, message = described_class.call(page: 1)

        expect(status).to eq(:internal_server_error)
        expect(message).to eq('history failed')
        expect(Rails.logger).to have_received(:error).with(error)
      end
    end

    context 'with invalid params' do
      before { allow(ThreatsHistory::Monad).to receive(:new) }

      it 'applies the contract and returns unprocessable_entity' do
        status, errors = described_class.call(page: 'not-an-integer')

        expect(status).to eq(:unprocessable_entity)
        expect(errors).to include(:page)
        expect(ThreatsHistory::Monad).not_to have_received(:new)
      end
    end
  end
end
