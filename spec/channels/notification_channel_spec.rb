# frozen_string_literal: true

require 'rails_helper'

RSpec.describe NotificationChannel, type: [:channel, :request] do
  describe 'subscription' do
    let(:token) { 'token' }

    context 'when send correctly connect params' do
      before do
        stub_connection token: token
        subscribe
      end

      it { expect(subscription).to be_confirmed }
    end

    context 'when send invalid connect params' do
      before do
        stub_connection token: nil
        subscribe
      end

      it { expect(subscription).not_to be_confirmed }
    end
  end
end
