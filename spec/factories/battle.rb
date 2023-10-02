# frozen_string_literal: true

FactoryBot.define do
  factory :battle do
    score { rand(40..60) }

    trait :allocate_resource do
      hero factory: %i[hero allocate_resource]
      threat factory: %i[threat allocate_resource]
      initialize_with { AllocateResource::Model::Battle.new(attributes) }
    end
  end
end
