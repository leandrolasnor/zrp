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

    trait :deallocate_resource do
      status { :working }
      initialize_with { DeallocateResource::Model::Hero.new(attributes) }
    end

    trait :dashboard do
      initialize_with { Dashboard::Model::Hero.new(attributes) }
    end

    trait :create_hero do
      initialize_with { Create::Hero::Models::Hero.new(attributes) }
    end

    trait :threats_history do
      initialize_with { ThreatsHistory::Model::Hero.new(attributes) }
    end

    trait :delete_hero do
      initialize_with { Delete::Hero::Models::Hero.new(attributes) }
    end
  end
end
