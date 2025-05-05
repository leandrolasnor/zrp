# frozen_string_literal: true

require 'rails_helper'
RSpec.describe ThreatsHistory::Monad do
  let(:call) { described_class.new(page: page, per_page: per_page).call }

  describe '.call' do
    let(:page) { 1 }
    let(:per_page) { 25 }

    it 'must be able to get a successfully process result' do
      expect(call).to be_success
    end
  end
end
