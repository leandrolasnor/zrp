# frozen_string_literal: true

require 'rails_helper'
RSpec.describe AlertReceives::UN::Model::Threat, type: :model do
  describe 'Enums' do
    let(:enum_status) { [:problem, :enabled, :disabled, :working] }
    let(:enum_rank) { [:wolf, :tiger, :dragon, :god] }

    it do
      expect(subject).to define_enum_for(:status).with_values(enum_status)
      expect(subject).to define_enum_for(:rank).with_values(enum_rank)
    end
  end

  describe 'MeiliSearch' do
    it { expect(described_class).to respond_to(:ms_raw_search) }
  end
end
