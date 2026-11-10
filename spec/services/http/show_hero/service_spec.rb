# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Http::ShowHero::Service do
  describe '.call' do
    context 'on Success' do
      let(:hero) { create(:hero, :create_hero) }

      it 'returns ok with the hero and serializer' do
        status, record, serializer = described_class.call(id: hero.id)

        expect(status).to eq(:ok)
        expect(record.id).to eq(hero.id)
        expect(serializer).to eq(Http::ShowHero::Serializer)
      end
    end

    context 'when the hero does not exist' do
      it 'raises ActiveRecord::RecordNotFound' do
        expect { described_class.call(id: 0) }
          .to raise_error(ActiveRecord::RecordNotFound)
      end
    end
  end
end
