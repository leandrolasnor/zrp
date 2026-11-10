# frozen_string_literal: true

FactoryBot.define do
  factory :threat do
    sequence(:name) { |n| "Threat #{n}" }
    rank { :wolf }
    status { 1 }
    lat { 0 }
    lng { 0 }
    payload do
      {
        location: { lat: lat, lng: lng },
        dangerLevel: rank,
        monsterName: name,
        monster: {
          name: name,
          url: 'https://photo.png',
          description: '...description'
        }
      }.to_json
    end

    trait :dashboard do
      initialize_with { Dashboard::Model::Threat.new(attributes) }
    end

    trait :allocate_resource do
      initialize_with { AllocateResource::Model::Threat.new(attributes) }
    end

    trait :deallocate_resource do
      status { :working }
      initialize_with { DeallocateResource::Model::Threat.new(attributes) }
    end

    trait :create_threat do
      initialize_with { CreateThreat::Model::Threat.new(attributes) }
    end

    trait :threats_history do
      initialize_with { ThreatsHistory::Model::Threat.new(attributes) }
    end
  end
end
