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

    describe 'score matrix' do
      let(:hero_values) { { c: 0, b: 1, a: 2, s: 3 } }
      let(:threat_values) { { wolf: 0, tiger: 1, dragon: 2, god: 3 } }

      def build_battle(hero_rank, threat_rank)
        build(
          :battle,
          :allocate_resource,
          hero: build(:hero, :allocate_resource, rank: hero_rank),
          threat: build(:threat, :allocate_resource, rank: threat_rank)
        )
      end

      def rank_score(hero_value, threat_value)
        [100 - ((100 / 3) * (hero_value - threat_value).abs), 0].max
      end

      it 'follows the rank and distance formula for every rank pair' do
        hero_values.each do |hero_rank, hero_value|
          threat_values.each do |threat_rank, threat_value|
            n = rank_score(hero_value, threat_value)
            battle = build_battle(hero_rank, threat_rank)

            expect(described_class.new(battle, distance: 0).score!).to eq(n / 2)
            expect(described_class.new(battle, distance: described_class::HALF.round).score!)
              .to eq((n + 100) / 2)
          end
        end
      end

      it 'caps the rank score at 100 for equal ranks' do
        battle = build_battle(:c, :wolf)

        expect(described_class.new(battle, distance: 0).score!).to eq(50)
        expect(described_class.new(battle, distance: described_class::HALF.round).score!).to eq(100)
      end
    end
  end
end
