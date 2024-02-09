# frozen_string_literal: true

require 'rails_helper'
RSpec.describe DeallocateResource::Model::Threat, type: :model do
  describe 'Enums' do
    let(:enum_status) { [:problem, :enabled, :disabled, :working] }

    it { is_expected.to define_enum_for(:status).with_values(enum_status) }
  end

  describe 'MeiliSearch' do
    it { expect(described_class).to respond_to(:ms_raw_search) }
  end
end
