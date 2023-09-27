# frozen_string_literal: true

require 'rails_helper'
RSpec.describe CreateThreat::Model::Threat, type: :model do
  describe 'Enums' do
    let(:enum_status) { [:problem, :enabled, :disabled] }
    let(:enum_rank) { [:god, :dragon, :tiger, :wolf] }

    it do
      expect(subject).to define_enum_for(:status).with_values(enum_status)
      expect(subject).to define_enum_for(:rank).with_values(enum_rank)
    end
  end
end
