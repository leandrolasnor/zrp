# frozen_string_literal: true

require 'rails_helper'
RSpec.describe ListHeroes::Monad do
  describe '.call' do
    subject { described_class.new.(page: page, per_page: per_page) }

    let(:list) { subject.value! }
    let(:page) { 1 }
    let(:per_page) { 2 }

    context 'on Success' do
      before { create_list(:hero, 2, :create_hero) }

      it 'must be able to get a list of heroes with two records' do
        expect(subject).to be_success
        expect(list.count).to eq(2)
        expect(list.first.id > list.second.id).to be_truthy
      end
    end
  end
end
