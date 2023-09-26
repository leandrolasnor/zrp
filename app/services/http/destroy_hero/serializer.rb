# frozen_string_literal: true

class Http::DestroyHero::Serializer < ActiveModel::Serializer
  attributes :id, :name, :rank, :lat, :lng
end
