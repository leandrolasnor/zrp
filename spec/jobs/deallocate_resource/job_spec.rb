# frozen_string_literal: true

require 'rails_helper'
require Rails.root.join('app/jobs/deallocate_resource/job').to_s

RSpec.describe 'DeallocateResource' do
  describe DeallocateResource::Service do
    describe '.call' do
      subject(:call) { described_class.new(threat_id).call }

      let(:threat_id) { 1 }
      let(:monad) { instance_double(DeallocateResource::Monad) }

      before { allow(DeallocateResource::Monad).to receive(:new).and_return(monad) }

      context 'on Success' do
        before { allow(monad).to receive(:call).and_return(Dry::Monads::Success(double)) }

        it 'does not raise' do
          expect { call }.not_to raise_error
        end
      end

      context 'on Failure' do
        let(:error) { StandardError.new('deallocation failed') }

        before do
          allow(monad).to receive(:call).and_return(Dry::Monads::Try::Error.new(error))
          allow(Rails.logger).to receive(:error)
        end

        it 'logs the error and raises a retryable error' do
          expect { call }.to raise_error(ApplicationJob::RetryableError, 'deallocation failed')
          expect(Rails.logger).to have_received(:error).with(error)
        end
      end
    end
  end

  describe DeallocateResource::Job do
    describe '#perform' do
      let(:service) { instance_double(DeallocateResource::Service, call: true) }

      before { allow(DeallocateResource::Service).to receive(:new).and_return(service) }

      it 'delegates to the service' do
        described_class.new.perform(1)

        expect(DeallocateResource::Service).to have_received(:new).with(1)
        expect(service).to have_received(:call)
      end
    end
  end
end
