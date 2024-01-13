# frozen_string_literal: true

FactoryBot.define do
  factory :hero do
    name { Faker::Name.unique.name }
    rank { rand(0..3) }
    lat { Faker::Address.latitude }
    lng { Faker::Address.longitude }

    trait :allocate_resource do
      initialize_with { AllocateResource::Model::Hero.new(attributes) }
    end

    trait :dashboard do
      initialize_with { Dashboard::Model::Hero.new(attributes) }
    end

    trait :create_hero do
      initialize_with { CreateHero::Model::Hero.new(attributes) }
    end
  end
end
