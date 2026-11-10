# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Http::DestroyHero::Service do
  describe '.call' do
    context 'on Success' do
      let(:hero) { create(:hero, :delete_hero) }

      before { allow(RemoveFromIndex::Job).to receive(:perform_later) }

      it 'destroys the hero and returns the serializer' do
        status, record, serializer = described_class.call(id: hero.id)

        expect(status).to eq(:ok)
        expect(record).to eq(hero)
        expect(serializer).to eq(Http::DestroyHero::Serializer)
        expect(hero.reload.deleted_at).to be_present
        expect(RemoveFromIndex::Job).to have_received(:perform_later)
          .with(id: hero.id, model: 'Delete::Hero::Models::Hero')
      end
    end

    context 'when the hero does not exist' do
      it 'returns unprocessable_entity with the destroy message' do
        status, message = described_class.call(id: 0)

        expect(status).to eq(:unprocessable_entity)
        expect(message).to eq(I18n.t(:cannot_destroy_hero))
      end
    end

    context 'with invalid params' do
      before { allow(Delete::Transaction).to receive(:include) }

      it 'applies the contract and returns unprocessable_entity' do
        status, errors = described_class.call(id: 'not-an-integer')

        expect(status).to eq(:unprocessable_entity)
        expect(errors).to include(:id)
        expect(Delete::Transaction).not_to have_received(:include)
      end
    end
  end
end
