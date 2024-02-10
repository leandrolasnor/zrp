# frozen_string_literal: true

require 'rails_helper'
RSpec.describe ListHeroes::Model::Hero, type: :model do
  describe 'Enums' do
    let(:enum_status) { [:disabled, :enabled, :working] }
    let(:enum_rank) { [:c, :b, :a, :s] }

    it do
      expect(subject).to define_enum_for(:status).with_values(enum_status)
      expect(subject).to define_enum_for(:rank).with_values(enum_rank)
    end
  end
end
