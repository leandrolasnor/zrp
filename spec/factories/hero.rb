# frozen_string_literal: true

FactoryBot.define do
  factory :hero do
    sequence(:name) { |n| "Hero #{n}" }
    rank { :c }
    lat { 0 }
    lng { 0 }

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
