# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Dashboard::Widgets::Job do
  describe '.widget_config' do
    it 'returns the configuration for a known widget' do
      expect(described_class.widget_config(:heroes_working)).to eq(
        event: 'WIDGET_HEROES_WORKING_FETCHED',
        queue: :critical
      )
    end

    it 'accepts the widget as a string' do
      expect(described_class.widget_config('super_hero')).to eq(
        event: 'WIDGET_SUPER_HERO_FETCHED',
        queue: :low_priority
      )
    end

    it 'raises for an unknown widget' do
      expect { described_class.widget_config(:unknown) }
        .to raise_error(ArgumentError, 'Unknown dashboard widget: unknown')
    end
  end

  describe '.enqueue' do
    let(:configured_job) { double }

    before do
      allow(described_class).to receive(:set).and_return(configured_job)
      allow(configured_job).to receive(:perform_later)
    end

    it 'enqueues the widget on its configured queue' do
      described_class.enqueue(:heroes_working)

      expect(described_class).to have_received(:set).with(queue: :critical)
      expect(configured_job).to have_received(:perform_later).with('heroes_working')
    end

    it 'enqueues low priority widgets on the low priority queue' do
      described_class.enqueue(:average_score)

      expect(described_class).to have_received(:set).with(queue: :low_priority)
      expect(configured_job).to have_received(:perform_later).with('average_score')
    end
  end

  describe '#perform' do
    let(:redis) { instance_double(Redis, publish: true, close: true) }
    let(:monad) { instance_double(Dashboard::Widgets::HeroesWorking::Monad) }

    before do
      allow(Redis).to receive(:new).and_return(redis)
      allow(Dashboard::Widgets::HeroesWorking::Monad).to receive(:new).and_return(monad)
    end

    context 'on Success' do
      let(:payload) { { global: 50, count: 2 } }

      before { allow(monad).to receive(:call).and_return(Dry::Monads::Success(payload)) }

      it 'publishes the widget payload and closes the redis connection' do
        described_class.new.perform('heroes_working')

        expect(redis).to have_received(:publish).with(
          'sse:widgets',
          { type: 'WIDGET_HEROES_WORKING_FETCHED', payload: payload }.to_json
        )
        expect(redis).to have_received(:close)
      end
    end

    context 'on Failure' do
      let(:error) { StandardError.new('widget failed') }

      before do
        allow(monad).to receive(:call).and_return(Dry::Monads::Try::Error.new(error))
        allow(Rails.logger).to receive(:error)
      end

      it 'logs the error, does not publish, and closes the redis connection' do
        described_class.new.perform('heroes_working')

        expect(Rails.logger).to have_received(:error).with(error)
        expect(redis).not_to have_received(:publish)
        expect(redis).to have_received(:close)
      end
    end

    context 'with an unknown widget' do
      it 'raises and closes the redis connection' do
        expect { described_class.new.perform('unknown') }.to raise_error(ArgumentError)
        expect(redis).to have_received(:close)
      end
    end
  end
end
