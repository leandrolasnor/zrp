# frozen_string_literal: true

require 'rails_helper'
RSpec.describe AllocateResource::Container do
  describe 'steps.find.call' do
    let(:call) { described_class['steps.find'].(id) }

    context 'on Success' do
      let(:threat) { create(:threat, :allocate_resource) }
      let(:id) { threat.id }

      it 'must be able to find the threat' do
        expect(call).to be_a(AllocateResource::Model::Threat)
        expect(call.id).to eq(threat.id)
      end
    end

    context 'on Failure' do
      let(:id) { 0 }

      it 'must be able to get a error' do
        expect { call }.to raise_error(ActiveRecord::RecordNotFound)
      end
    end
  end

  describe 'steps.matches.call' do
    let(:call) { described_class['steps.matches'].(threat) }

    describe '.call' do
      let(:threat) { create(:threat, :allocate_resource, rank: :god) }

      before do
        threat
      end

      context 'on Success' do
        let(:hero_a) { create(:hero, :allocate_resource, rank: :a) }
        let(:hero_b) { create(:hero, :allocate_resource, rank: :b) }

        before do
          hero_a
          hero_b
        end

        it 'must be able to create at least two matches' do
          expect(call.count).to be >= 2
          expect(call.first.threat).to eq(threat)
        end
      end

      context 'on Failure' do
        before do
          allow(AllocateResource::Model::Hero)
            .to receive(:allocatable)
            .with(5)
            .and_return([])
        end

        it 'must be able to get insufficient resources error' do
          expect { call }.to raise_error(I18n.t(:insufficient_resources))
        end
      end
    end
  end

  describe 'steps.sort.call' do
    let(:call) { described_class['steps.sort'].(matches) }
    let(:matches) do
      threat = create(:threat, :allocate_resource)
      heroes = create_list(:hero, 3, :allocate_resource)
      battle1 = build(:battle, :allocate_resource, hero: heroes[0], threat: threat)
      battle2 = build(:battle, :allocate_resource, hero: heroes[1], threat: threat)
      battle3 = build(:battle, :allocate_resource, hero: heroes[2], threat: threat)
      [battle1, battle2, battle3]
    end

    it 'must be able to sort the matches array by score' do
      expect(call).to be_a(Array)
      expect(call.first.score!).to be >= call.second.score!
      expect(call.second.score!).to be >= call.third.score!
    end
  end

  describe 'steps.allocate.call' do
    let(:call) { described_class['steps.allocate'].(matches_sorted) }

    context 'when threats rank is equal heros first rank' do
      let(:threat) { create(:threat, :allocate_resource, rank: :god) }
      let(:heroes) do
        [
          create(:hero, :allocate_resource, rank: :s),
          create(:hero, :allocate_resource, rank: :c)
        ]
      end
      let(:matches_sorted) do
        [
          build(:battle, :allocate_resource, hero: heroes.first, threat: threat),
          build(:battle, :allocate_resource, hero: heroes.second, threat: threat)
        ]
      end

      before { call }

      it 'must be able to choose a the first match' do
        expect(threat).to be_working
        expect(heroes.first).to be_working
        expect(heroes.second).to be_enabled
        expect(matches_sorted.first).to be_persisted
      end
    end

    context 'when heros second is the chosen' do
      let(:threat) { create(:threat, :allocate_resource, rank: :god) }
      let(:heroes) do
        [
          create(:hero, :allocate_resource, rank: :c),
          create(:hero, :allocate_resource, rank: :s)
        ]
      end
      let(:matches_sorted) do
        [
          build(:battle, :allocate_resource, hero: heroes.first, threat: threat),
          build(:battle, :allocate_resource, hero: heroes.second, threat: threat)
        ]
      end

      before { call }

      it 'must be able to choose a the second match' do
        expect(threat).to be_working
        expect(heroes.first).to be_enabled
        expect(heroes.second).to be_working
        expect(matches_sorted.second).to be_persisted
      end
    end

    context 'when two heroes are the chosen' do
      let(:threat) { create(:threat, :allocate_resource, rank: :god) }
      let(:heroes) do
        [
          create(:hero, :allocate_resource, rank: :c),
          create(:hero, :allocate_resource, rank: :a)
        ]
      end
      let(:matches_sorted) do
        [
          build(:battle, :allocate_resource, hero: heroes.first, threat: threat),
          build(:battle, :allocate_resource, hero: heroes.second, threat: threat)
        ]
      end

      before { call }

      it 'must be able to choose both matches' do
        expect(threat).to be_working
        expect(heroes.first).to be_working
        expect(heroes.second).to be_working
        expect(matches_sorted.first).to be_persisted
        expect(matches_sorted.second).to be_persisted
      end
    end

    context 'when no hero is chosen' do
      let(:threat) { create(:threat, :allocate_resource, rank: :wolf) }
      let(:heroes) do
        [
          create(:hero, :allocate_resource, rank: :b),
          create(:hero, :allocate_resource, rank: :a)
        ]
      end
      let(:matches_sorted) do
        [
          build(:battle, :allocate_resource, hero: heroes.first, threat: threat),
          build(:battle, :allocate_resource, hero: heroes.second, threat: threat)
        ]
      end

      before { call }

      it 'must not be able to choose a match' do
        expect(threat).to be_enabled
        expect(heroes.first).to be_enabled
        expect(heroes.second).to be_enabled
        expect(matches_sorted.first).not_to be_persisted
        expect(matches_sorted.second).not_to be_persisted
      end
    end
  end
end
