# frozen_string_literal: true

require 'rails_helper'
RSpec.describe AllocateResource::Model::Hero, type: :model do
  describe 'Scope and Search Engine' do
    it do
      expect(described_class).to respond_to(:ms_raw_search)
      expect(described_class).to respond_to(:allocatable)
    end
  end

  describe 'Enums' do
    let(:enum_status) { [:disabled, :enabled, :working] }
    let(:enum_rank) { [:c, :b, :a, :s] }

    it do
      expect(subject).to define_enum_for(:status).with_values(enum_status)
      expect(subject).to define_enum_for(:rank).with_values(enum_rank)
    end
  end
end
