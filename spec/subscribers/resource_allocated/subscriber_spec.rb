# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ResourceAllocated::Subscriber do
  describe '.call' do
    let(:battle) { create(:battle, :allocate_resource) }
    let(:threat) { battle.threat }
    let(:event) { { threat: threat } }
    let(:configured_job) { double }

    before do
      allow(DeallocateResource::Job).to receive(:set).and_return(configured_job)
      allow(configured_job).to receive(:perform_later)
      allow(Dashboard::Widgets::Job).to receive(:enqueue)
      allow(RES).to receive(:pub)
    end

    it 'schedules the deallocation, refreshes widgets, and publishes the event' do
      described_class.call(event)

      expect(DeallocateResource::Job).to have_received(:set)
        .with(wait_until: threat.battles.first.finished_at)
      expect(configured_job).to have_received(:perform_later).with(threat.id)
      expect(Dashboard::Widgets::Job).to have_received(:enqueue).with(:average_score)
      expect(Dashboard::Widgets::Job).to have_received(:enqueue).with(:average_time_to_match)
      expect(Dashboard::Widgets::Job).to have_received(:enqueue).with(:battles_lineup)
      expect(Dashboard::Widgets::Job).to have_received(:enqueue).with(:heroes_working)
      expect(Dashboard::Widgets::Job).to have_received(:enqueue).with(:super_hero)
      expect(RES).to have_received(:pub)
        .with(ResourceAllocated, "Threat##{threat.id}", {
          threat: threat, heroes: threat.heroes,
          battles: threat.battles
        })
    end
  end
end
