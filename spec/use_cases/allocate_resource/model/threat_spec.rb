# frozen_string_literal: true

require 'rails_helper'
RSpec.describe AllocateResource::Model::Threat, type: :model do
  describe 'Associations' do
    it do
      expect(subject).to have_many(:battles)
      expect(subject).to have_many(:heroes).through(:battles)
    end
  end

  describe 'Enums' do
    let(:enum_status) { [:problem, :enabled, :disabled, :working] }
    let(:enum_rank) { [:wolf, :tiger, :dragon, :god] }

    it do
      expect(subject).to define_enum_for(:status).with_values(enum_status)
      expect(subject).to define_enum_for(:rank).with_values(enum_rank)
    end
  end

  describe 'AASM' do
    context 'on success' do
      it 'must be able to transitions from: %i[enabled working], to: :working' do
        expect(subject).to transition_from(:enabled).to(:working).on_event(:working)
        expect(subject).to transition_from(:working).to(:working).on_event(:working)
      end

      it 'must be able to transitions from: %i[working disabled], to: :disabled' do
        expect(subject).to transition_from(:working).to(:disabled).on_event(:disabled)
        expect(subject).to transition_from(:disabled).to(:disabled).on_event(:disabled)
      end

      it 'must be able to transitions from: %i[enabled disabled problem], to: :problem' do
        expect(subject).to transition_from(:enabled).to(:problem).on_event(:problem)
        expect(subject).to transition_from(:disabled).to(:problem).on_event(:problem)
        expect(subject).to transition_from(:problem).to(:problem).on_event(:problem)
      end
    end

    context 'on failure' do
      it 'must not be able to transactions from: :problem, to: :working' do
        expect(subject).not_to transition_from(:problem).to(:working).on_event(:working)
      end

      it 'must not be able to transactions from: :problem, to: :disabled' do
        expect(subject).not_to transition_from(:problem).to(:disabled).on_event(:disabled)
      end
    end
  end
end
