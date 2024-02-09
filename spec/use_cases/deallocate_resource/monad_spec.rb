# frozen_string_literal: true

require 'rails_helper'
RSpec.describe DeallocateResource::Monad do
  describe '.call' do
    let(:call) { subject.(battle.threat.id) }

    context 'on Success' do
      let(:battle) { create(:battle, :deallocate_resource) }

      it 'must be able to disable the threat and to enable the hero' do
        expect(battle.threat).to be_working
        expect(battle.hero).to be_working
        call
        expect(battle.threat.reload).to be_disabled
        expect(battle.hero.reload).to be_enabled
      end
    end
  end
end
