# frozen_string_literal: true

require 'rails_helper'
RSpec.describe AllocateResource::Steps::Matches do
  let(:call) { subject.(threat) }

  describe '.call' do
    let(:threat) { create(:threat, :allocate_resource, rank: :god) }

    before do
      threat
    end

    context 'on Success' do
      let(:hero_a) { create(:hero, :allocate_resource, rank: :a) }
      let(:hero_b) { create(:hero, :allocate_resource, rank: :b) }

      before do
        hero_a
        hero_b
      end

      it 'must be able to create at least two matches' do
        expect(call.count).to be >= 2
        expect(call.first.threat).to eq(threat)
      end
    end

    context 'on Failure' do
      before do
        allow(AllocateResource::Model::Hero)
          .to receive(:allocatable)
          .with(5)
          .and_return([])
      end

      it 'must be able to get insufficient resources error' do
        expect { call }.to raise_error(I18n.t(:insufficient_resources))
      end
    end
  end
end
