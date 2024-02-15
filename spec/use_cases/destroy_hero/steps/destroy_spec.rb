# frozen_string_literal: true

require 'rails_helper'
RSpec.describe DestroyHero::Steps::Destroy do
  describe '.call' do
    let(:call) { described_class.new.(subject) }

    context 'on Success' do
      subject { create(:hero, :destroy_hero) }

      before { call }

      it { is_expected.to be_deleted }
    end

    context 'on Failure' do
      subject { create(:hero, :destroy_hero, status: :working) }

      it { expect { call }.to raise_error(StandardError, I18n.t(:hero_working, hero: subject.name)) }
      it { is_expected.not_to be_deleted }
    end
  end
end
