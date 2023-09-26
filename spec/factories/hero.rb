# frozen_string_literal: true

FactoryBot.define do
  factory :hero do
    name { Faker::Name.unique.name }
    rank { rand(0..3) }
    lat { Faker::Number.between(from: -160.0, to: 180.0).truncate(3) }
    lng { Faker::Number.between(from: -80.0, to: 90.0).truncate(3) }
  end
end
