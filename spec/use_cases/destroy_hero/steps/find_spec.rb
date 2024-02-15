# frozen_string_literal: true

require 'rails_helper'
RSpec.describe DestroyHero::Steps::Find do
  describe '.call' do
    subject { described_class.new.(id: id) }

    context 'on Success' do
      let(:hero) { create(:hero, :destroy_hero) }
      let(:id) { hero.id }

      it { is_expected.to be_a(DestroyHero::Model::Hero) }
    end

    context 'on Failure' do
      let(:id) { 0 }

      it do
        expect { subject }.to raise_error(
          ActiveRecord::RecordNotFound,
          "Couldn't find DestroyHero::Model::Hero with 'id'=0 [WHERE \"heroes\".\"deleted_at\" IS NULL]"
        )
      end
    end
  end
end
