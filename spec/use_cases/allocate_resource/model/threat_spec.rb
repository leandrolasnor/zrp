# frozen_string_literal: true

require 'rails_helper'
RSpec.describe AllocateResource::Model::Threat, type: :model do
  describe 'Associations' do
    it do
      expect(subject).to have_many(:battles)
      expect(subject).to have_many(:heroes).through(:battles)
    end
  end

  describe 'Enums' do
    let(:enum_status) { [:problem, :enabled, :disabled, :working] }
    let(:enum_rank) { [:wolf, :tiger, :dragon, :god] }

    it do
      expect(subject).to define_enum_for(:status).with_values(enum_status)
      expect(subject).to define_enum_for(:rank).with_values(enum_rank)
    end
  end
end
