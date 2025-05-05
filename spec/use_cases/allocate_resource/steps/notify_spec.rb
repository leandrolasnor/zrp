# frozen_string_literal: true

require 'rails_helper'
RSpec.describe AllocateResource::Steps::Notify do
  describe '.call' do
    let(:call) { subject.(threat) }
    let(:threat) { create(:threat, :allocate_resource) }

    context 'when threat is enabled' do
      before do
        threat.enabled!
        allow(AppEvents).to receive(:publish).with('resource.not.allocated', threat: threat)
        call
      end

      it 'must be able to notify with resource.not.allocated event' do
        expect(AppEvents).to have_received(:publish).with('resource.not.allocated', threat: threat)
      end
    end

    context 'when threat is working' do
      before do
        threat.working!
        allow(AppEvents).to receive(:publish).with('resource.allocated', threat: threat)
        call
      end

      it 'must be able to notify with resource.allocated event' do
        expect(AppEvents).to have_received(:publish).with('resource.allocated', threat: threat)
      end
    end
  end
end
