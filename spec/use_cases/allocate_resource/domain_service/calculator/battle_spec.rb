# frozen_string_literal: true

require 'rails_helper'
RSpec.describe AllocateResource::DomainService::Calculator::Battle do
  describe '.score!' do
    subject(:calculator) { described_class.new(battle, distance: distance) }

    let(:distance) { 0 }
    let(:hero_rank) { :c }
    let(:threat_rank) { :wolf }
    let(:battle) do
      build(
        :battle,
        :allocate_resource,
        hero: build(:hero, :allocate_resource, rank: hero_rank),
        threat: build(:threat, :allocate_resource, rank: threat_rank)
      )
    end

    it 'must be able to calculate battle score' do
      expect(calculator.score!).to be_integer
    end

    it 'assigns the calculated score to the battle' do
      expect { calculator.score! }.to change(battle, :score)
    end

    context 'when the ranks are different' do
      let(:hero_rank) { :s }
      let(:threat_rank) { :wolf }

      it 'penalizes the score by the rank difference' do
        expect(calculator.score!).to eq(0)
      end

      it 'scores lower than a same-rank battle' do
        same_rank = described_class.new(
          build(
            :battle,
            :allocate_resource,
            hero: build(:hero, :allocate_resource, rank: :s),
            threat: build(:threat, :allocate_resource, rank: :god)
          ),
          distance: distance
        )

        expect(calculator.score!).to be < same_rank.score!
      end
    end

    context 'when the ranks are equal' do
      let(:hero_rank) { :s }
      let(:threat_rank) { :god }

      it 'does not penalize the score' do
        expect(calculator.score!).to eq(50)
      end

      context 'with a large distance' do
        let(:distance) { (described_class::HALF + 1).round }

        it 'maximizes the score' do
          expect(calculator.score!).to eq(100)
        end
      end

      context 'with half the maximum distance' do
        let(:distance) { (described_class::HALF / 2).round }

        it 'returns the average of rank and distance scores' do
          expect(calculator.score!).to eq(75)
        end
      end
    end
  end
end
