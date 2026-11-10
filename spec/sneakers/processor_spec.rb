# frozen_string_literal: true

require 'rails_helper'
require './sneakers/processor'

RSpec.describe Processor do
  subject(:processor) { described_class.new }

  describe '.work' do
    let(:message) { { monsterName: 'Joker', dangerLevel: 'God', location: { lat: 0, lng: 0 } }.to_json }
    let(:retry_key) { "sneakers:retry:#{Digest::SHA256.hexdigest(message)}" }
    let(:client) { double }
    let(:threat) { Rpc::Threat.new(name: 'Joker', rank: 'god', status: 'enabled', lat: 0, lng: 0) }

    before do
      allow(processor).to receive(:ihero).and_return(client)
      allow(Rails.cache).to receive(:read).with('SNEAKERS_REQUEUE').and_return(false)
    end

    context 'when need trigger message requeue' do
      before do
        allow(processor).to receive(:reject!)
        allow(Rails.cache).to receive(:read).with('SNEAKERS_REQUEUE').and_return(true)
        processor.work(message)
      end

      it 'must be able to requeue message' do
        expect(processor).to have_received(:reject!)
      end
    end

    context 'when the occurrence is a threat' do
      before do
        allow(client).to receive(:call).and_return(double(message: threat))
        allow(processor).to receive(:ack!)
        allow(Rails.cache).to receive(:delete)
        processor.work(message)
      end

      it 'acknowledges the message and clears the retry count' do
        expect(processor).to have_received(:ack!)
        expect(Rails.cache).to have_received(:delete).with(retry_key)
      end
    end

    context 'when the retry limit is exhausted' do
      let(:exchange) { double(publish: true) }

      before do
        allow(client).to receive(:call).and_return(double(message: nil))
        allow(processor).to receive(:dead_exchange).and_return(exchange)
        allow(processor).to receive(:ack!)
        allow(Rails.cache).to receive(:read).with(retry_key).and_return(described_class::MAX_RETRIES)
        allow(Sneakers.logger).to receive(:error)
        processor.work(message)
      end

      it 'dead-letters the message and acknowledges it' do
        expect(exchange).to have_received(:publish)
          .with(message, routing_key: 'dead', persistent: true)
        expect(processor).to have_received(:ack!)
        expect(Sneakers.logger).to have_received(:error)
          .with('Max retries reached, discarding message to dead queue')
      end
    end

    context 'when the retry limit is not exhausted' do
      before do
        allow(client).to receive(:call).and_return(double(message: nil))
        allow(processor).to receive(:reject!)
        allow(Rails.cache).to receive(:read).with(retry_key).and_return(0)
        allow(Rails.cache).to receive(:increment)
        processor.work(message)
      end

      it 'increments the retry count and rejects the message' do
        expect(Rails.cache).to have_received(:increment)
          .with(retry_key, 1, expires_in: described_class::RETRY_TTL)
        expect(processor).to have_received(:reject!)
      end
    end

    context 'with invalid JSON' do
      let(:message) { 'invalid json' }
      let(:exchange) { double(publish: true) }

      before do
        allow(processor).to receive(:dead_exchange).and_return(exchange)
        allow(processor).to receive(:ack!)
        allow(Sneakers.logger).to receive(:error)
        processor.work(message)
      end

      it 'dead-letters the message to the parser error queue' do
        expect(exchange).to have_received(:publish)
          .with(message, routing_key: 'parser.error', persistent: true)
        expect(processor).to have_received(:ack!)
      end
    end

    context 'when dead-lettering fails' do
      let(:message) { 'invalid json' }
      let(:exchange) { double }

      before do
        allow(exchange).to receive(:publish).and_raise(StandardError, 'broker down')
        allow(processor).to receive(:dead_exchange).and_return(exchange)
        allow(processor).to receive(:ack!)
        allow(Sneakers.logger).to receive(:error)
        processor.work(message)
      end

      it 'logs the failure and acknowledges the message' do
        expect(processor).to have_received(:ack!)
        expect(Sneakers.logger).to have_received(:error)
          .with('Failed to dead-letter message: broker down')
      end
    end

    context 'when the rpc client raises' do
      let(:error) { StandardError.new('rpc down') }

      before do
        allow(client).to receive(:call).and_raise(error)
        allow(processor).to receive(:handle_retry)
        allow(Sneakers.logger).to receive(:error)
        processor.work(message)
      end

      it 'logs the error and handles the retry' do
        expect(Sneakers.logger).to have_received(:error)
        expect(processor).to have_received(:handle_retry).with(message)
      end
    end
  end
end
