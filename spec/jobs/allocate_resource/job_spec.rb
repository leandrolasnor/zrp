# frozen_string_literal: true

require 'rails_helper'
RSpec.describe AllocateResource::Job do
  let(:perform) { described_class.new.perform(threat.id) }
  let(:threat) { create(:threat, :allocate_resource) }
  let(:job) { double }
  let(:redis_instance) { double }

  context 'on Failure' do
    context 'on matches step' do
      let(:error_message) { I18n.t(:insufficient_resources) }

      before do
        allow(AllocateResource::Model::Hero).to receive(:allocatable).with(5).and_return([])
        allow(Rails.logger).to receive(:error).with(error_message)
        allow(described_class).to receive(:set).with(wait: 1.minute).and_return(job)
        allow(job).to receive(:perform_later).with(threat.id)
        allow(REDIS).to receive(:with).and_yield(redis_instance)
        allow(redis_instance).to receive(:set).with('SNEAKERS_REQUEUE', true, ex: 60)
        perform
      end

      it 'must be able to write error on logger' do
        expect(Rails.logger).to have_received(:error).with(error_message)
        expect(job).to have_received(:perform_later).with(threat.id)
        expect(redis_instance).to have_received(:set).with('SNEAKERS_REQUEUE', true, ex: 60)
      end
    end

    context 'on find step' do
      let(:perform) { described_class.new.perform(0) }

      before do
        allow(Rails.logger).to receive(:error)
        perform
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
      allow(Dashboard::Widgets::HeroesWorking::Job).to receive(:perform_later)
      allow(Dashboard::Widgets::BattlesLineup::Job).to receive(:perform_later)
      allow(Dashboard::Widgets::AverageScore::Job).to receive(:perform_later)
      allow(Dashboard::Widgets::AverageTimeToMatch::Job).to receive(:perform_later)
      allow(Dashboard::Widgets::SuperHero::Job).to receive(:perform_later)
      allow(DeallocateResource::Job)
        .to receive(:set)
        .with(wait_until: duck_type(:to_time))
        .and_return(job)
      allow(job).to receive(:perform_later).with(threat.id)
      heroes
      perform
    end

    it 'must be able to create a threat and allocate heroes' do
      expect(Dashboard::Widgets::HeroesWorking::Job).to have_received(:perform_later)
      expect(Dashboard::Widgets::BattlesLineup::Job).to have_received(:perform_later)
      expect(Dashboard::Widgets::AverageScore::Job).to have_received(:perform_later)
      expect(Dashboard::Widgets::AverageTimeToMatch::Job).to have_received(:perform_later)
      expect(Dashboard::Widgets::SuperHero::Job).to have_received(:perform_later)
      expect(job).to have_received(:perform_later).with(threat.id)
    end
  end
end
