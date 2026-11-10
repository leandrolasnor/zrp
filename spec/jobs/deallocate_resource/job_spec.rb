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

        it 'does not schedule another deallocation' do
          allow(DeallocateResource::Job).to receive(:perform_later)

          call

          expect(DeallocateResource::Job).not_to have_received(:perform_later)
        end
      end

      context 'on Failure' do
        let(:error) { StandardError.new('deallocation failed') }

        before do
          allow(monad).to receive(:call).and_return(Dry::Monads::Try::Error.new(error))
          allow(Rails.logger).to receive(:error)
          allow(DeallocateResource::Job).to receive(:perform_later)
        end

        it 'logs the error and schedules the job again' do
          call

          expect(Rails.logger).to have_received(:error).with(error)
          expect(DeallocateResource::Job).to have_received(:perform_later).with(threat_id)
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
