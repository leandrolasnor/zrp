# frozen_string_literal: true

require 'rails_helper'
RSpec.describe Delete::Hero::Container do
  describe 'steps.find.call' do
    subject { described_class['steps.find'].(**params) }

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

  describe 'steps.destroy.call' do
    let(:call) { described_class['steps.destroy'].(subject) }

    context 'on Success' do
      subject { create(:hero, :delete_hero) }

      before { call }

      it { is_expected.to be_deleted }
    end

    context 'on Failure' do
      subject { nil }

      it { expect { call }.to raise_error(StandardError, I18n.t(:cannot_destroy_hero)) }
    end
  end
end
