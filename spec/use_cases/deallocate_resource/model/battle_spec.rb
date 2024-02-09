# frozen_string_literal: true

require 'rails_helper'
RSpec.describe DeallocateResource::Model::Battle, type: :model do
  describe 'Associations' do
    it { is_expected.to belong_to(:threat) }
    it { is_expected.to belong_to(:hero) }
  end
end
