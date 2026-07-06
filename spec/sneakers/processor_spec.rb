# frozen_string_literal: true

require 'rails_helper'
require './sneakers/processor'

RSpec.describe Processor do
  describe '.work' do
    let(:work) { subject.work(message) }
    let(:message) { 'message' }

    context 'when need trigger message requeue' do
      before do
        allow(subject).to receive(:reject!)
        allow(Rails.cache).to receive(:read).with('SNEAKERS_REQUEUE').and_return(true)
        work
      end

      it 'must be able to requeue message' do
        expect(subject).to have_received(:reject!)
      end
    end
  end
end
