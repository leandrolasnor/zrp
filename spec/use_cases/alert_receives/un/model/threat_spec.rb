# frozen_string_literal: true

require 'rails_helper'
RSpec.describe AlertReceives::UN::Model::Threat, type: :model do
  describe 'Enums' do
    let(:enum_status) { [:problem, :enabled, :disabled, :working] }
    let(:enum_rank) { [:wolf, :tiger, :dragon, :god] }

    it do
      expect(subject).to define_enum_for(:status).with_values(enum_status)
      expect(subject).to define_enum_for(:rank).with_values(enum_rank)
    end
  end

  describe 'AASM' do
    context 'on working' do
      it 'must be able to transition from enabled to working' do
        expect(subject).to transition_from(:enabled).to(:working).on_event(:working)
      end

      it 'must be able to transition from working to working' do
        expect(subject).to transition_from(:working).to(:working).on_event(:working)
      end
    end

    context 'on disabled' do
      it 'must be able to transition from working to disabled' do
        expect(subject).to transition_from(:working).to(:disabled).on_event(:disabled)
      end

      it 'must be able to transition from problem to disabled' do
        expect(subject).to transition_from(:problem).to(:disabled).on_event(:disabled)
      end

      it 'must be able to transition from disabled to disabled' do
        expect(subject).to transition_from(:disabled).to(:disabled).on_event(:disabled)
      end
    end

    context 'on problem' do
      it 'must be able to transition from enabled to problem' do
        expect(subject).to transition_from(:enabled).to(:problem).on_event(:problem)
      end

      it 'must be able to transition from disabled to problem' do
        expect(subject).to transition_from(:disabled).to(:problem).on_event(:problem)
      end

      it 'must be able to transition from problem to problem' do
        expect(subject).to transition_from(:problem).to(:problem).on_event(:problem)
      end
    end
  end

  describe 'MeiliSearch' do
    it { expect(described_class).to respond_to(:ms_raw_search) }
  end
end
