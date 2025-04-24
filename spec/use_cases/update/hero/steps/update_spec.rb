# frozen_string_literal: true

require 'rails_helper'
RSpec.describe Update::Hero::Steps::Update do
  let(:updated) { subject.(record: hero, **params) }
  let(:hero) do
    create(
      :hero,
      :create_hero,
      name: ' Hero Name',
      rank: 0,
      status: 0
    )
  end

  describe '.call' do
    context 'on Success' do
      let(:params) do
        {
          id: hero.id,
          name: 'Other hero name',
          rank: 1,
          status: 2
        }
      end

      it 'must be able to update hero' do
        expect(updated.name).to eq('Other hero name')
        expect(updated.rank).to eq('b')
        expect(updated.status).to eq('working')
        expect(updated.id).to eq(hero.id)
      end
    end
  end
end
