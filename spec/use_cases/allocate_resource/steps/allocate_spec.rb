# frozen_string_literal: true

require 'rails_helper'
RSpec.describe AllocateResource::Steps::Allocate do
  describe '.call' do
    let(:call) { subject.(matches_sorted) }

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

      before do
        allow(heroes.first).to receive(:with_lock).and_yield
        allow(heroes.second).to receive(:with_lock).and_yield
        allow(threat).to receive(:with_lock).and_yield
        call
      end

      it 'must be able to choose a the first match' do
        expect(heroes.first).to have_received(:with_lock)
        expect(threat).to have_received(:with_lock)
        expect(heroes.second).not_to have_received(:with_lock)
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

      before do
        allow(heroes.first).to receive(:with_lock).and_yield
        allow(heroes.second).to receive(:with_lock).and_yield
        allow(threat).to receive(:with_lock).and_yield
        call
      end

      it 'must be able to choose a the second match' do
        expect(heroes.second).to have_received(:with_lock)
        expect(threat).to have_received(:with_lock)
        expect(heroes.first).not_to have_received(:with_lock)
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

      before do
        allow(heroes.first).to receive(:with_lock).and_yield
        allow(heroes.second).to receive(:with_lock).and_yield
        allow(threat).to receive(:with_lock).and_yield
        call
      end

      it 'must be able to choose both matches' do
        expect(heroes.first).to have_received(:with_lock)
        expect(heroes.second).to have_received(:with_lock)
        expect(threat).to have_received(:with_lock).twice
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

      before do
        allow(heroes.first).to receive(:with_lock).and_yield
        allow(heroes.second).to receive(:with_lock).and_yield
        allow(threat).to receive(:with_lock).and_yield
        call
      end

      it 'must not be able to choose a match' do
        expect(heroes.second).not_to have_received(:with_lock)
        expect(threat).not_to have_received(:with_lock)
        expect(heroes.first).not_to have_received(:with_lock)
        expect(threat).to be_enabled
        expect(heroes.first).to be_enabled
        expect(heroes.second).to be_enabled
        expect(matches_sorted.first).not_to be_persisted
        expect(matches_sorted.second).not_to be_persisted
      end
    end
  end
end
