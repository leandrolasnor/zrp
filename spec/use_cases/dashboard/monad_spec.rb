# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Dashboard::Monad do
  describe '.call' do
    subject(:monad) { described_class.new(metrics: metrics) }

    let(:success_widget) { Dashboard::Widgets::HeroesWorking::Monad.new }
    let(:failure_widget) { Dashboard::Widgets::AverageScore::Monad.new }
    let(:metrics) { [success_widget, failure_widget] }

    before do
      allow(success_widget).to receive(:call).and_return(Dry::Monads::Success({ global: 50 }))
      allow(failure_widget).to receive(:call)
        .and_return(Dry::Monads::Try::Error.new(StandardError.new('widget failed')))
    end

    it 'maps each widget to its name and value, using nil for failures' do
      result = monad.call

      expect(result).to be_success
      expect(result.value!).to eq(heroes_working: { global: 50 }, average_score: nil)
    end
  end
end
