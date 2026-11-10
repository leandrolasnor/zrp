# frozen_string_literal: true

require 'rails_helper'

RSpec.describe InsufficientResources::Subscriber do
  describe '.call' do
    let(:threat) { create(:threat, :allocate_resource) }
    let(:event) { { threat: threat } }
    let(:configured_job) { double }

    before do
      allow(Rails.cache).to receive(:write)
      allow(AllocateResource::Job).to receive(:set).and_return(configured_job)
      allow(configured_job).to receive(:perform_later)
      allow(RES).to receive(:pub)
    end

    it 'requeues the allocation and publishes the event' do
      described_class.call(event)

      expect(Rails.cache).to have_received(:write).with('SNEAKERS_REQUEUE', true, expires_in: 1.minute)
      expect(AllocateResource::Job).to have_received(:set).with(wait: 1.minute)
      expect(configured_job).to have_received(:perform_later).with(threat.id)
      expect(RES).to have_received(:pub).with(InsufficientResources, "Threat##{threat.id}")
    end
  end
end
