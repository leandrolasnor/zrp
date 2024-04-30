# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ApplicationCable::Connection, type: [:channel, :request] do
  let(:connect_to) { connect(param) }

  context 'when connections param is correct' do
    let(:token) { 'token' }
    let(:param) { "/cable" }

    before do
      connect_to
    end

    it 'must be able to get successful connection' do
      expect(connection.token).to eq token
    end
  end
end
