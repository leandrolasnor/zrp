# frozen_string_literal: true

require 'rails_helper'
require './sneakers/processor'

RSpec.describe Processor do
  describe '.work' do
    let(:work) { subject.work(message) }
    let(:message) { 'message' }

    context 'when need trigger message requeue' do
      let(:redis_instance) { double }

      before do
        allow(subject).to receive(:requeue!)
        allow(redis_instance).to receive(:get).with('SNEAKERS_REQUEUE').and_return('true')
        allow(REDIS).to receive(:with).and_yield(redis_instance)
        work
      end

      it 'must be able to requeue message' do
        expect(subject).to have_received(:requeue!)
      end
    end
  end
end
