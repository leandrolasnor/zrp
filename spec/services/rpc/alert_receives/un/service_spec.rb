# frozen_string_literal: true

require 'rails_helper'
RSpec.describe Rpc::AlertReceives::UN::Service do
  describe '#call' do
    subject { described_class.call(request.message.to_h) }

    let(:request) do
      Gruf::Controllers::Request.new(
        method_key: :handle,
        service: Rpc::UN::Service,
        active_call: { metadata: { 'user_id' => 'axj42i' } },
        message: Rpc::Occurrence.new(params),
        rpc_desc: Rpc::UN::Service.rpc_descs[:Handle]
      )
    end

    context 'on Success' do
      context 'when threat is persisted' do
        let(:params) do
          {
            location: {
              lat: 70.3877,
              lng: -42.78323345726754
            },
            dangerLevel: 'Tiger',
            monsterName: 'Eobard Thawne'
          }
        end

        before do
          allow(AllocateResource::Job).to receive(:perform_later).with(kind_of(Integer))
          allow(Dashboard::Widgets::ThreatsDisabled::Job).to receive(:perform_later)
          allow(Dashboard::Widgets::ThreatsDistribution::Job).to receive(:perform_later)
        end

        it 'must be able to return a Rpc::Threat instance' do
          expect(subject).to be_a(Rpc::Threat)
          expect(subject.lat).to eq(params.dig(:location, :lat))
          expect(subject.lng).to eq(params.dig(:location, :lng))
          expect(AllocateResource::Job).to have_received(:perform_later).with(kind_of(Integer))
          expect(Dashboard::Widgets::ThreatsDisabled::Job).to have_received(:perform_later)
          expect(Dashboard::Widgets::ThreatsDistribution::Job).to have_received(:perform_later)
        end
      end
    end

    context 'on Exception' do
      let(:params) do
        {
          location: {
            lat: 70.3870,
            lng: -42.7832
          },
          dangerLevel: 'TiGeR',
          monsterName: 'Eobard Thawne'
        }
      end

      before do
        allow(AllocateResource::Job).to receive(:perform_later).with(kind_of(Integer))
        allow(Dashboard::Widgets::ThreatsDisabled::Job).to receive(:perform_later)
        allow(Dashboard::Widgets::ThreatsDistribution::Job).to receive(:perform_later)
      end

      it 'must be able to raise a exception' do
        expect { subject }.to raise_error(StandardError)
        expect(AllocateResource::Job).not_to have_received(:perform_later).with(kind_of(Integer))
        expect(Dashboard::Widgets::ThreatsDisabled::Job).not_to have_received(:perform_later)
        expect(Dashboard::Widgets::ThreatsDistribution::Job).not_to have_received(:perform_later)
      end
    end
  end
end
