# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Http::ThreatsHistory::Serializer do
  subject(:serializer) { described_class.new(threat) }

  let(:battle_serializer) { serializer.battle }

  context 'when the threat has a battle' do
    let(:hero) { create(:hero, :threats_history, name: 'Superman', rank: :s) }
    let(:threat) { create(:threat, :threats_history, name: 'Dragon', rank: :dragon) }
    let!(:battle) do
      create(:battle, :threats_history, threat: threat, hero: hero, score: 90)
    end

    it 'serializes the threat and its battle' do
      expect(serializer.as_json).to include(
        id: threat.id,
        name: 'Dragon',
        rank: 'dragon',
        lat: threat.lat,
        lng: threat.lng
      )
      expect(battle_serializer.as_json).to include(
        score: 90,
        finished_at: battle.finished_at,
        created_at: battle.created_at
      )
      expect(battle_serializer.duration).to be_a(Hash)
      expect(battle_serializer.heroes.map(&:as_json)).to include(
        include(name: 'Superman', rank: 's')
      )
    end
  end

  context 'when the threat has no battle' do
    let(:threat) { create(:threat, :threats_history, name: 'Lone Threat', rank: :wolf) }

    it 'serializes the threat without raising' do
      expect(serializer.as_json).to include(id: threat.id, name: 'Lone Threat', rank: 'wolf')
      expect(battle_serializer.as_json).to include(
        score: nil,
        duration: nil,
        finished_at: nil,
        created_at: nil
      )
      expect(battle_serializer.heroes).to eq([])
    end
  end
end
