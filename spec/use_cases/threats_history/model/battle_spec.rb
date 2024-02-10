# frozen_string_literal: true

require 'rails_helper'
RSpec.describe ThreatsHistory::Model::Battle, type: :model do
  describe 'Associations' do
    it { expect(subject).to belong_to(:threat) }
    it { expect(subject).to belong_to(:hero) }
  end
end
