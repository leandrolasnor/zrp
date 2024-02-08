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
        allow(subject).to receive(:publish).with('resource.allocated', threat: threat)
        call
      end

      it 'must be able to choose a the first match' do
        expect(threat).to be_working
        expect(heroes.first).to be_working
        expect(heroes.second).to be_enabled
        expect(matches_sorted.first).to be_persisted
        expect(subject).to have_received(:publish).with('resource.allocated', threat: threat)
      end
    end

    context 'when threats rank is equal heros second rank' do
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
        allow(subject).to receive(:publish).with('resource.allocated', threat: threat)
        call
      end

      it 'must be able to choose a the second match' do
        expect(threat).to be_working
        expect(heroes.first).to be_enabled
        expect(heroes.second).to be_working
        expect(matches_sorted.second).to be_persisted
        expect(subject).to have_received(:publish).with('resource.allocated', threat: threat)
      end
    end

    context 'when threats rank is greater than heros second rank and heros first rank' do
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
        allow(subject).to receive(:publish).with('resource.allocated', threat: threat)
        call
      end

      it 'must be able to choose both matches' do
        expect(threat).to be_working
        expect(heroes.first).to be_working
        expect(heroes.second).to be_working
        expect(matches_sorted.first).to be_persisted
        expect(matches_sorted.second).to be_persisted
        expect(subject).to have_received(:publish).with('resource.allocated', threat: threat)
      end
    end

    context 'when there are not able heroes with rank enough' do
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
        allow(subject).to receive(:publish).with('resource.not.allocated')
        call
      end

      it 'must not be able to choose a match' do
        expect(threat).to be_enabled
        expect(heroes.first).to be_enabled
        expect(heroes.second).to be_enabled
        expect(matches_sorted.first).not_to be_persisted
        expect(matches_sorted.second).not_to be_persisted
        expect(subject).to have_received(:publish).with('resource.not.allocated')
      end
    end
  end
end
