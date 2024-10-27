# frozen_string_literal: true

require 'rails_helper'
RSpec.describe Rpc::AlertReceives::UN::Service do
  describe '#call' do
    subject { described_class.call(request.message.to_h) }

    let(:allocate_resource_job) { Rpc::AlertReceives::UN::Listeners::AllocateResource::Job }
    let(:threat_disabled_job) { Rpc::AlertReceives::UN::Listeners::Dashboard::Widgets::ThreatsDisabled::Job }

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
          allow(Resque).to receive(:enqueue).with(allocate_resource_job, kind_of(Integer))
          allow(Resque).to receive(:enqueue_at).with(duck_type(:to_time), threat_disabled_job)
          allow(Resque).to receive(:size).with(anything).and_return(0)
        end

        it 'must be able to return a Rpc::Threat instance' do
          expect(subject).to be_a(Rpc::Threat)
          expect(subject.lat).to eq(params.dig(:location, :lat))
          expect(subject.lng).to eq(params.dig(:location, :lng))
          expect(Resque).to have_received(:enqueue).with(allocate_resource_job, kind_of(Integer))
          expect(Resque).to have_received(:enqueue_at).with(duck_type(:to_time), threat_disabled_job)
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
        allow(Resque).to receive(:enqueue).with(allocate_resource_job, kind_of(Integer))
        allow(Resque).to receive(:enqueue_at).with(duck_type(:to_time), threat_disabled_job)
      end

      it 'must be able to raise a exception' do
        expect { subject }.to raise_error(StandardError)
        expect(Resque).not_to have_received(:enqueue).with(allocate_resource_job, kind_of(Integer))
        expect(Resque).not_to have_received(:enqueue_at).with(duck_type(:to_time), threat_disabled_job)
      end
    end
  end
end
