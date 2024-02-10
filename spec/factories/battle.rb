# frozen_string_literal: true

FactoryBot.define do
  factory :battle do
    score { rand(40..60) }
    finished_at { 1.minute.from_now }

    trait :allocate_resource do
      hero factory: %i[hero allocate_resource]
      threat factory: %i[threat allocate_resource]
      initialize_with { AllocateResource::Model::Battle.new(attributes) }
    end

    trait :deallocate_resource do
      hero factory: %i[hero deallocate_resource]
      threat factory: %i[threat deallocate_resource]
      initialize_with { DeallocateResource::Model::Battle.new(attributes) }
    end

    trait :threats_history do
      hero factory: %i[hero threats_history]
      threat factory: %i[threat threats_history]
      initialize_with { ThreatsHistory::Model::Battle.new(attributes) }
    end
  end
end
