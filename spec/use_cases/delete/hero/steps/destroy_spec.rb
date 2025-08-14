# frozen_string_literal: true

require 'rails_helper'
RSpec.describe Delete::Hero::Steps::Destroy do
  describe '.call' do
    let(:call) { described_class.new.(subject) }

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
