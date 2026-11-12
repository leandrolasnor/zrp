# frozen_string_literal: true

require 'rails_helper'

RSpec.describe HeroRemovedFromIndex::Subscriber do
  describe '.call' do
    let(:document) { { id: 1, name: 'Hero' } }
    let(:event) { { model: 'Delete::Hero::Models::Hero', id: 1, document: document } }

    before do
      allow(Dashboard::Widgets::Job).to receive(:enqueue)
      allow(RES).to receive(:pub)
    end

    it 'refreshes widgets and publishes the event' do
      described_class.call(event)

      expect(Dashboard::Widgets::Job).to have_received(:enqueue).with(:heroes_working)
      expect(Dashboard::Widgets::Job).to have_received(:enqueue).with(:heroes_distribution)
      expect(RES).to have_received(:pub)
        .with(HeroRemovedFromIndex, 'Hero#1', document)
    end
  end
end
