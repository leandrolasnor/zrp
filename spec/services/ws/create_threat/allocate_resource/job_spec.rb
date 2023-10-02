# frozen_string_literal: true

require 'rails_helper'
RSpec.describe Ws::CreateThreat::AllocateResource::Job do
  let(:call) { described_class.new.call(threat.id) }
  let(:threat) { create(:threat, :allocate_resource) }

  context 'on Failure' do
    context 'on matches step' do
      let(:matches) { double }
      let(:error_message) { I18n.t(:insufficient_resources) }

      before do
        allow(AllocateResource::Model::Hero).to receive(:allocatable).with(25).and_return([])
        allow(Rails.logger).to receive(:error).with(error_message)
        allow(Resque).to receive(:enqueue_at).with(duck_type(:to_time), described_class, threat.id)
        call
      end

      it 'must be able to write error on logger' do
        expect(Rails.logger).to have_received(:error).with(error_message)
        expect(Resque).to have_received(:enqueue_at).with(duck_type(:to_time), described_class, threat.id)
      end
    end

    context 'on find step' do
      let(:call) { described_class.new.call(0) }

      before do
        allow(Rails.logger).to receive(:error)
        call
      end

      it 'must be able to write error on logger' do
        expect(Rails.logger).to have_received(:error)
      end
    end
  end

  context 'on Success' do
    let(:heroes) do
      hero1 = build(:hero, :allocate_resource)
      hero2 = build(:hero, :allocate_resource)

      hero1.rank = CreateThreat::Model::Threat.ranks[threat.rank]
      hero1.lat = threat.lat
      hero1.lng = threat.lng
      hero2.lat = threat.lng
      hero2.lng = threat.lat

      hero1.save
      hero2.save

      [hero1, hero2]
    end

    before do
      allow(Resque).
        to receive(:enqueue_at).
        with(duck_type(:to_time), Ws::CreateThreat::DeallocateResource::Job, threat.id)
      heroes
      call
    end

    it 'must be able to create a threat and allocate heroes' do
      expect(Resque).
        to have_received(:enqueue_at).
        with(duck_type(:to_time), Ws::CreateThreat::DeallocateResource::Job, threat.id)
    end
  end
end
