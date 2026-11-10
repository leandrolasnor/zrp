# frozen_string_literal: true

require 'rails_helper'

RSpec.describe UNThreatCreated::Subscriber do
  describe '.call' do
    let(:threat) { create(:threat, :allocate_resource) }
    let(:event) { { threat: threat } }

    before do
      allow(AllocateResource::Job).to receive(:perform_later)
      allow(Dashboard::Widgets::Job).to receive(:enqueue)
      allow(RES).to receive(:pub)
    end

    it 'starts the allocation, refreshes widgets, and publishes the event' do
      described_class.call(event)

      expect(AllocateResource::Job).to have_received(:perform_later).with(threat.id)
      expect(Dashboard::Widgets::Job).to have_received(:enqueue).with(:threats_disabled)
      expect(Dashboard::Widgets::Job).to have_received(:enqueue).with(:threats_distribution)
      expect(RES).to have_received(:pub)
        .with(UN::AlertReceived, "Threat##{threat.id}", threat.payload)
    end
  end
end
