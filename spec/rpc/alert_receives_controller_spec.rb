# frozen_string_literal: true

require 'rails_helper'
RSpec.describe AlertReceivesController do
  it { expect(grpc_bound_service).to eq Rpc::UN::Service }

  describe '#alert' do
    context 'on Success' do
      subject { run_rpc(:Alert, Rpc::Occurrence.new(message), active_call_options: { metadata: metadata }) }

      let(:metadata) { { 'user_id' => 'axj42i' } }
      let(:message) do
        {
          monsterName: 'Joker',
          dangerLevel: 'God',
          location: {
            lat: -39.93849382083,
            lng: 21.287293837223
          }
        }
      end

      it 'returns the thing' do
        expect(subject).to be_a_successful_rpc
        expect(subject).to be_a(Rpc::Threat)
        expect(subject.status).to eq 'enabled'
      end
    end

    context 'on Failure' do
      subject { run_rpc(:Alert, Rpc::Threat.new(message), active_call_options: { metadata: metadata }) }

      let(:metadata) { { 'user_id' => 'axj42i' } }
      let(:message) do
        {
          name: 'Joker',
          rank: 'god',
          lat: -39.93849382083,
          lng: 21.287293837223,
          status: 'enabled'
        }
      end

      it 'fails with the appropriate error' do
        expect { subject }.to raise_rpc_error(GRPC::Internal)
      end
    end
  end
end
