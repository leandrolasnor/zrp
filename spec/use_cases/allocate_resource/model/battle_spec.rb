# frozen_string_literal: true

require 'rails_helper'
RSpec.describe AllocateResource::Model::Battle, type: :model do
  it do
    expect(subject).to belong_to(:hero)
    expect(subject).to belong_to(:threat)
    expect(subject).to delegate_method(:score!).to(:calculator)
  end
end
