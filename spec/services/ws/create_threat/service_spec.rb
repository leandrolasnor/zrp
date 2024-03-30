# frozen_string_literal: true

require 'rails_helper'
RSpec.describe Ws::CreateThreat::Service do
  describe '#call' do
    let(:res) { described_class.call(params) }
    let(:job) { Ws::CreateThreat::Listeners::AllocateResource::Job }

    context 'on Success' do
      let(:threat) { res.value!.attributes.symbolize_keys.except(:created_at, :updated_at) }

      context 'when payload layout is correct' do
        let(:params) do
          {
            location: [{ lat: 70.38704353933477, lng: -42.78322998876705 }],
            dangerLevel: 'Tiger',
            monsterName: 'Eobard Thawne',
            monster: {
              name: 'Eobard Thawne',
              url: 'https://upload.wikimedia.org/wikipedia/en/8/8e/Reverse-Flash_%28Eobard_Thawne%29.png',
              description: 'Eobard Thawne, otherwise known as the Reverse-Flash and Professor Zoom, is a fictional supervillain appearing in American comic books published by DC Comics. The character was created by John Broome and Carmine Infantino, and first appeared in The Flash #139 in September 1963.'
            }
          }
        end

        let(:expected_record) do
          {
            id: be_a(Integer),
            name: 'Eobard Thawne',
            status: 'enabled',
            rank: 'tiger',
            lat: BigDecimal('0.7038704353933477e2'),
            lng: BigDecimal('-0.4278322998876705e2'),
            payload: params.to_json
          }
        end

        before do
          allow(Resque).to receive(:enqueue).with(job, kind_of(Integer))
        end

        it 'must be able to create a threat with enable status' do
          expect(res).to be_success
          expect(threat).to match(expected_record)
          expect(Resque).to have_received(:enqueue).with(job, kind_of(Integer))
        end
      end

      context 'when payload layout is wrong' do
        let(:params) do
          {
            lat: 70.38704353933477,
            lng: -42.78322998876705,
            rank: 'Tiger',
            name: 'Eobard Thawne',
            monster: {
              name: 'Eobard Thawne',
              url: 'https://upload.wikimedia.org/wikipedia/en/8/8e/Reverse-Flash_%28Eobard_Thawne%29.png',
              description: 'Eobard Thawne, otherwise known as the Reverse-Flash and Professor Zoom, is a fictional supervillain appearing in American comic books published by DC Comics. The character was created by John Broome and Carmine Infantino, and first appeared in The Flash #139 in September 1963.'
            }
          }
        end

        let(:expected_record) do
          {
            id: be_a(Integer),
            name: be_nil,
            status: 'problem',
            rank: be_nil,
            lat: be_nil,
            lng: be_nil,
            payload: params.to_json
          }
        end

        before do
          allow(Resque).to receive(:enqueue).with(job, kind_of(Integer))
        end

        it 'must be able to create a threat with problem status' do
          expect(res).to be_success
          expect(threat).to match(expected_record)
          expect(Resque).not_to have_received(:enqueue).with(job, kind_of(Integer))
        end
      end
    end

    context 'on Failure' do
      let(:res) { described_class.call({}) }
      let(:error) { StandardError.new }

      before do
        allow(described_class).to receive(:new).and_raise(error)
        allow(Rails.logger).to receive(:error).with(error)
      end

      it 'must be able to get a failure response' do
        expect(res).to be_failure
        expect(Rails.logger).to have_received(:error).with(error)
      end
    end
  end
end
