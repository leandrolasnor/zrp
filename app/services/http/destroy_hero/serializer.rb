# frozen_string_literal: true

class Http::DestroyHero::Serializer < ActiveModel::Serializer
  attributes :name, :rank, :lat, :lng
end
