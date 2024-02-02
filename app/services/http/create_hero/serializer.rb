# frozen_string_literal: true

class Http::CreateHero::Serializer < ActiveModel::Serializer
  attributes :id, :name, :status, :rank, :lat, :lng
end
