# frozen_string_literal: true

require 'rails_helper'
require './sneakers/readiness'

RSpec.describe Readiness do
  describe '.amqp_ready?' do
    let(:worker) { double }

    it 'is true when the consumer channel is open' do
      allow(worker).to receive(:queue).and_return(double(channel: double(open?: true)))

      expect(described_class.amqp_ready?(worker)).to be(true)
    end

    it 'is false when the channel is closed or missing' do
      allow(worker).to receive(:queue).and_return(double(channel: nil))

      expect(described_class.amqp_ready?(worker)).to be(false)
    end

    it 'is false when the worker has no queue' do
      allow(worker).to receive(:queue).and_raise(StandardError, 'not started')

      expect(described_class.amqp_ready?(worker)).to be(false)
    end
  end

  describe '.grpc_ready?' do
    it 'is true when the tcp connection succeeds' do
      allow(Socket).to receive(:tcp).with('grpc', 50051, connect_timeout: 1).and_yield

      expect(described_class.grpc_ready?('grpc:50051')).to be(true)
    end

    it 'is false when the connection is refused' do
      allow(Socket).to receive(:tcp).and_raise(Errno::ECONNREFUSED)

      expect(described_class.grpc_ready?('grpc:50051')).to be(false)
    end

    it 'is false for a malformed hostname' do
      expect(described_class.grpc_ready?('grpc')).to be(false)
    end
  end

  describe '.ready?' do
    it 'requires both services' do
      worker = double

      allow(described_class).to receive(:amqp_ready?).with(worker).and_return(true)
      allow(described_class).to receive(:grpc_ready?).with('grpc:50051').and_return(false)
      expect(described_class.ready?(worker, 'grpc:50051')).to be(false)

      allow(described_class).to receive(:grpc_ready?).with('grpc:50051').and_return(true)
      expect(described_class.ready?(worker, 'grpc:50051')).to be(true)
    end
  end

  describe '.infrastructure_error?' do
    it 'recognizes grpc connectivity failures' do
      expect(described_class.infrastructure_error?(Gruf::Client::Errors::Unavailable.new('down'))).to be(true)
      expect(described_class.infrastructure_error?(Errno::ECONNREFUSED.new)).to be(true)
    end

    it 'does not classify validation errors as infrastructure failures' do
      expect(described_class.infrastructure_error?(Gruf::Client::Errors::InvalidArgument.new('invalid'))).to be(false)
      expect(described_class.infrastructure_error?(StandardError.new)).to be(false)
    end
  end
end
