# frozen_string_literal: true

require 'rails_helper'
RSpec.describe AlertReceivesController do
  subject { run_rpc(:Alert, Rpc::Occurrence.new(message), active_call_options: { metadata: metadata }) }

  let(:metadata) { { 'user_id' => 'axj42i' } }

  it { expect(grpc_bound_service).to eq Rpc::UN::Service }

  describe '#alert' do
    context 'on Success' do
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

      it 'must be able to get a successfull response' do
        expect(subject).to be_a_successful_rpc
        expect(subject).to be_a(Rpc::Threat)
        expect(subject.status).to eq 'enabled'
      end
    end

    context 'on Failure' do
      context 'on ArgumentError' do
        let(:message) do
          {
            monsterName: '',
            dangerLevel: '8234@#@KPJJ@C#',
            location: {
              latitude: '-39.93849382083',
              longitude: '21.287293837223'
            }
          }
        end

        it 'must be able to get a ArgumentError' do
          expect { subject }.to raise_rpc_error(ArgumentError)
        end
      end

      context 'on GRPC::Internal' do
        subject { run_rpc(:Alert, Rpc::Threat.new(message), active_call_options: { metadata: metadata }) }

        let(:message) do
          {
            name: 'Joker',
            rank: 'god',
            lat: -39.93849382083,
            lng: 21.287293837223,
            status: 'enabled'
          }
        end

        it 'must be able to get a GRPC::Internal' do
          expect { subject }.to raise_rpc_error(GRPC::Internal)
        end
      end
    end
  end
end
