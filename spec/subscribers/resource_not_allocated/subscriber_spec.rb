# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ResourceNotAllocated::Subscriber do
  describe '.call' do
    let(:battle) { build(:battle, :allocate_resource) }
    let(:threat) { battle.threat }
    let(:event) { { threat: threat, matches_sorted: [battle] } }

    before do
      allow(AllocateResource::Job).to receive(:perform_later)
      allow(Dashboard::Widgets::Job).to receive(:enqueue)
      allow(RES).to receive(:pub)
    end

    it 'requeues the allocation, refreshes widgets, and publishes the event' do
      described_class.call(event)

      expect(AllocateResource::Job).to have_received(:perform_later).with(threat.id)
      expect(Dashboard::Widgets::Job).to have_received(:enqueue).with(:heroes_distribution)
      expect(RES).to have_received(:pub).with(
        ResourceNotAllocated,
        "Threat##{threat.id}",
        [battle.hero].to_json
      )
    end
  end
end
