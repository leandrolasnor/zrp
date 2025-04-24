# frozen_string_literal: true

require 'rails_helper'
RSpec.describe Delete::Hero::Steps::RemoveFromIndex do
  describe '.call' do
    let(:destroyed) { double }
    let(:call) { subject.call(destroyed) }

    context 'on Success' do
      before do
        allow(destroyed).to receive(:remove_from_index!)
        call
      end

      it do
        expect(destroyed).to have_received(:remove_from_index!)
        expect(call).to eq(destroyed)
      end
    end

    context 'on Failure' do
      before do
        allow(destroyed).to receive(:remove_from_index!).and_raise(StandardError.new('message'))
      end

      it { expect { call }.to raise_error(StandardError) }
    end
  end
end
