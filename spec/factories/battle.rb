# frozen_string_literal: true

FactoryBot.define do
  factory :battle do
    score { rand(40..60) }

    trait :make_matches do
      hero factory: %i[hero make_matches]
      threat factory: %i[threat make_matches]
      initialize_with { MakeMatches::Model::Battle.new(attributes) }
    end

    trait :allocate_resource do
      hero factory: %i[hero allocate_resource]
      threat factory: %i[threat allocate_resource]
      initialize_with { AllocateResource::Model::Battle.new(attributes) }
    end
  end
end
