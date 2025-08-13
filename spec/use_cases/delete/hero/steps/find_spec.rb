# frozen_string_literal: true

require 'rails_helper'
RSpec.describe Delete::Hero::Steps::Find do
  describe '.call' do
    subject { described_class.new.(**params) }

    let(:params) { { id: id } }

    context 'on Success' do
      context 'when hero found' do
        let(:hero) { create(:hero, :delete_hero) }
        let(:id) { hero.id }

        it { is_expected.to be_a(Delete::Hero::Models::Hero) }
      end

      context 'when hero not found' do
        let(:hero) { create(:hero, :delete_hero, status: :working) }
        let(:id) { hero.id }

        it { is_expected.to be_nil }
      end
    end
  end
end
