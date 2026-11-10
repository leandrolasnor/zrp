# frozen_string_literal: true

require 'rails_helper'
require Rails.root.join('app/jobs/remove_from_index/job').to_s

RSpec.describe 'RemoveFromIndex' do
  describe RemoveFromIndex::Service do
    describe '.call' do
      subject(:call) { described_class.new(model:, id:).call }

      let(:model) { 'Delete::Hero::Models::Hero' }
      let(:id) { 1 }
      let(:monad) { instance_double(RemoveFromIndex::Monad) }

      before { allow(RemoveFromIndex::Monad).to receive(:new).and_return(monad) }

      context 'on Success' do
        let(:document) { { id: id, name: 'Hero' } }

        before do
          allow(monad).to receive(:call).and_return(Dry::Monads::Success(document))
          allow(AppEvents).to receive(:publish)
        end

        it 'publishes the hero_removed_from_index event' do
          call

          expect(AppEvents).to have_received(:publish).with(
            'hero_removed_from_index',
            model: model,
            id: id,
            document: document
          )
        end
      end

      context 'on Failure' do
        let(:configured_job) { double }

        before do
          allow(monad).to receive(:call).and_return(Dry::Monads::Try::Error.new(StandardError.new))
          allow(RemoveFromIndex::Job).to receive(:set).and_return(configured_job)
          allow(configured_job).to receive(:perform_later)
        end

        it 'schedules a retry' do
          call

          expect(RemoveFromIndex::Job).to have_received(:set).with(wait: 5.seconds)
          expect(configured_job).to have_received(:perform_later).with(model:, id:)
        end
      end
    end
  end

  describe RemoveFromIndex::Job do
    describe '#perform' do
      let(:service) { instance_double(RemoveFromIndex::Service, call: true) }

      before { allow(RemoveFromIndex::Service).to receive(:new).and_return(service) }

      it 'delegates to the service' do
        described_class.new.perform(model: 'Delete::Hero::Models::Hero', id: 1)

        expect(RemoveFromIndex::Service).to have_received(:new)
          .with(model: 'Delete::Hero::Models::Hero', id: 1)
        expect(service).to have_received(:call)
      end
    end
  end
end
