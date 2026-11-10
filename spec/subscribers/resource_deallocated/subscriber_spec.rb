# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ResourceDeallocated::Subscriber do
  describe '.call' do
    let(:battle) { create(:battle, :deallocate_resource) }
    let(:threat) { battle.threat }
    let(:event) { { threat: threat } }

    before do
      allow(Dashboard::Widgets::Job).to receive(:enqueue)
      allow(RES).to receive(:pub)
    end

    it 'refreshes widgets and publishes the event' do
      described_class.call(event)

      expect(Dashboard::Widgets::Job).to have_received(:enqueue).with(:heroes_working)
      expect(Dashboard::Widgets::Job).to have_received(:enqueue).with(:threats_disabled)
      expect(RES).to have_received(:pub)
        .with(ResourceDeallocated, "Threat##{threat.id}", threat.heroes.to_json)
    end
  end
end
