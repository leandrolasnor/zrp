# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Create::ShortenedUrl::DomainService::Generator::ShortenedUrl do
  describe '.code!' do
    subject { described_class.new(build(:shortened_url, :create_shortened_url)) }

    it 'must be able to generate short code' do
      subject.code!
      expect(subject.send(:shortened_url).code.length).to eq 7
    end
  end
end
