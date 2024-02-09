# frozen_string_literal: true

require 'rails_helper'
RSpec.describe AllocateResource::Steps::Find do
  describe '.call' do
    let(:call) { subject.(id) }

    context 'on Success' do
      let(:threat) { create(:threat, :allocate_resource) }
      let(:id) { threat.id }

      it 'must be able to find the threat' do
        expect(call).to be_a(AllocateResource::Model::Threat)
        expect(call.id).to eq(threat.id)
      end
    end

    context 'on Failure' do
      let(:id) { 0 }

      it 'must be able to get a error' do
        expect { call }.to raise_error(ActiveRecord::RecordNotFound)
      end
    end
  end
end
