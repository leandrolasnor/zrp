# frozen_string_literal: true

require 'rails_helper'
RSpec.describe CRUD::Update::Hero::Steps::Edit do
  let(:updated) { subject.(params) }
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

      before do
        allow(subject).
          to receive(:publish).
          with(
            'hero.edited',
            hash_including(
              hero: duck_type(
                :name,
                :status,
                :rank,
                :id,
                :lat,
                :lng
              )
            )
          )
      end

      it 'must be able to update hero' do
        expect(updated.name).to eq('Other hero name')
        expect(updated.rank).to eq('b')
        expect(updated.status).to eq('working')
        expect(updated.id).to eq(hero.id)
        expect(subject).
          to have_received(:publish).
          with(
            'hero.edited',
            hash_including(
              hero: duck_type(
                :name,
                :status,
                :rank,
                :id,
                :lat,
                :lng
              )
            )
          )
      end
    end
  end
end
