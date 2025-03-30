# frozen_string_literal: true

require 'rails_helper'
RSpec.describe Rpc::AlertReceives::UN::Listeners::AllocateResource::Job do
  let(:call) { described_class.new.call(threat.id) }
  let(:threat) { create(:threat, :allocate_resource) }

  context 'on Failure' do
    context 'on matches step' do
      let(:error_message) { I18n.t(:insufficient_resources) }
      let(:redis_instance) { double }

      before do
        allow(AllocateResource::Model::Hero).to receive(:allocatable).with(5).and_return([])
        allow(Rails.logger).to receive(:error).with(error_message)
        allow(Resque).to receive(:enqueue_at).with(duck_type(:to_time), described_class, threat.id)
        allow(REDIS).to receive(:with).and_yield(redis_instance)
        allow(redis_instance).to receive(:set).with('SNEAKERS_REQUEUE', true)
        call
      end

      it 'must be able to write error on logger' do
        expect(Rails.logger).to have_received(:error).with(error_message)
        expect(Resque).to have_received(:enqueue_at).with(duck_type(:to_time), described_class, threat.id)
        expect(redis_instance).to have_received(:set).with('SNEAKERS_REQUEUE', true)
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

      hero1.rank = AlertReceives::UN::Model::Threat.ranks[threat.rank]
      hero1.lat = threat.lat
      hero1.lng = threat.lng
      hero2.lat = threat.lat
      hero2.lng = threat.lng

      hero1.save
      hero2.save

      [hero1, hero2]
    end

    before do
      allow(Rpc::AlertReceives::UN::Listeners::Dashboard::Widgets::HeroesWorking::Job).to receive(:perform)
      allow(Resque).to receive(:enqueue).with(Rpc::AlertReceives::UN::Listeners::Dashboard::Widgets::BattlesLineup::Job)
      allow(Resque).to receive(:enqueue).with(Rpc::AlertReceives::UN::Listeners::Dashboard::Widgets::AverageScore::Job)
      allow(Resque).
        to receive(:enqueue_at).
        with(duck_type(:to_time), Rpc::AlertReceives::UN::Listeners::DeallocateResource::Job, threat.id)
      allow(Resque).
        to receive(:enqueue).
        with(Rpc::AlertReceives::UN::Listeners::Dashboard::Widgets::AverageTimeToMatch::Job)
      allow(Resque).
        to receive(:enqueue).
        with(Rpc::AlertReceives::UN::Listeners::Dashboard::Widgets::SuperHero::Job)
      heroes
      call
    end

    it 'must be able to create a threat and allocate heroes' do
      expect(Rpc::AlertReceives::UN::Listeners::Dashboard::Widgets::HeroesWorking::Job).to have_received(:perform)
      expect(Resque).
        to have_received(:enqueue).
        with(Rpc::AlertReceives::UN::Listeners::Dashboard::Widgets::AverageScore::Job)
      expect(Resque).
        to have_received(:enqueue_at).
        with(duck_type(:to_time), Rpc::AlertReceives::UN::Listeners::DeallocateResource::Job, threat.id)
      expect(Resque).
        to have_received(:enqueue).
        with(Rpc::AlertReceives::UN::Listeners::Dashboard::Widgets::BattlesLineup::Job)
      expect(Resque).
        to have_received(:enqueue).
        with(Rpc::AlertReceives::UN::Listeners::Dashboard::Widgets::AverageTimeToMatch::Job)
      expect(Resque).
        to have_received(:enqueue).
        with(Rpc::AlertReceives::UN::Listeners::Dashboard::Widgets::SuperHero::Job)
    end
  end
end
