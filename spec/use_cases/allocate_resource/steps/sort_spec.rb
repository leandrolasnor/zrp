# frozen_string_literal: true

require 'rails_helper'
RSpec.describe AllocateResource::Steps::Sort do
  describe '.call' do
    let(:call) { subject.(matches) }
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
end
