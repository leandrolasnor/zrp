# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Http::ApplicationService do
  let(:contract) do
    Class.new(ApplicationContract) do
      params do
        required(:id).filled(:integer)
      end
    end
  end

  describe '.call' do
    context 'when the service declares a nested contract' do
      before do
        stub_const('NestedService', Class.new(described_class) do
          def call = [:ok, params]
        end)
        NestedService.const_set(:Contract, contract)
      end

      it 'validates the params with the nested contract' do
        expect(NestedService.call(id: 'not-an-integer'))
          .to eq([:unprocessable_entity, { id: ['must be an integer'] }])
      end

      it 'symbolizes the params before building the service' do
        expect(NestedService.call('id' => 1)).to eq([:ok, { id: 1 }])
      end
    end

    context 'when the contract is a sibling constant' do
      before do
        stub_const('SiblingModule::Service', Class.new(described_class) do
          def call = [:ok, params]
        end)
        stub_const('SiblingModule::Contract', contract)
      end

      it 'validates the params with the sibling contract' do
        expect(SiblingModule::Service.call(id: 'not-an-integer'))
          .to eq([:unprocessable_entity, { id: ['must be an integer'] }])
      end
    end

    context 'when the service has no contract' do
      before do
        stub_const('NoContractService', Class.new(described_class) do
          def call = [:ok, params]
        end)
      end

      it 'calls the service directly' do
        expect(NoContractService.call('id' => 1)).to eq([:ok, { id: 1 }])
      end
    end

    context 'when the service raises ActiveRecord::RecordNotFound' do
      before do
        stub_const('NotFoundService', Class.new(described_class) do
          def call = raise(ActiveRecord::RecordNotFound)
        end)
      end

      it 're-raises the error so the controller can render not_found' do
        expect { NotFoundService.call({}) }.to raise_error(ActiveRecord::RecordNotFound)
      end
    end

    context 'when the service raises any other error' do
      before do
        stub_const('ErrorService', Class.new(described_class) do
          def call = raise(StandardError, 'boom')
        end)
        allow(Rails.logger).to receive(:error)
      end

      it 'logs the error and returns internal_server_error' do
        expect(ErrorService.call({})).to eq([:internal_server_error])
        expect(Rails.logger).to have_received(:error).with(instance_of(StandardError))
      end
    end
  end
end
