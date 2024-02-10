# frozen_string_literal: true

require 'rails_helper'
RSpec.describe ThreatsHistory::Model::Threat, type: :model do
  describe 'Associations' do
    it { expect(subject).to have_many(:battles) }
    it { expect(subject).to have_many(:heroes).through(:battles) }
  end

  describe 'Enums' do
    let(:enum_status) { [:problem, :enabled, :disabled, :working] }
    let(:enum_rank) { [:wolf, :tiger, :dragon, :god] }

    it do
      expect(subject).to define_enum_for(:status).with_values(enum_status)
      expect(subject).to define_enum_for(:rank).with_values(enum_rank)
    end
  end

  describe 'Scopes' do
    it { expect(described_class).to respond_to(:fresh) }
  end
end
