# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Http::Dashboard::Service do
  describe '.call' do
    let(:monad) { instance_double(Dashboard::Monad) }

    before { allow(Dashboard::Monad).to receive(:new).and_return(monad) }

    context 'on Success' do
      let(:widgets) { { heroes_working: { global: 50 } } }

      before { allow(monad).to receive(:call).and_return(Dry::Monads::Success(widgets)) }

      it 'returns ok with the dashboard widgets' do
        expect(described_class.call({})).to eq([:ok, widgets])
      end
    end

    context 'on Failure' do
      let(:error) { StandardError.new('dashboard failed') }

      before do
        allow(monad).to receive(:call).and_return(Dry::Monads::Try::Error.new(error))
        allow(Rails.logger).to receive(:error)
      end

      it 'logs the error and returns internal_server_error' do
        expect(described_class.call({})).to eq([:internal_server_error])
        expect(Rails.logger).to have_received(:error).with(error)
      end
    end
  end
end
