# frozen_string_literal: true

require 'rails_helper'
RSpec.describe ThreatsHistory::Model::Hero, type: :model do
  describe 'Enums' do
    let(:enum_rank) { [:c, :b, :a, :s] }

    it { is_expected.to define_enum_for(:rank).with_values(enum_rank) }
  end
end
