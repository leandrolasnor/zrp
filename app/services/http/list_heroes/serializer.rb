# frozen_string_literal: true

class Http::ListHeroes::Serializer < ActiveModel::Serializer
  attributes :id, :name, :rank, :lat, :lng
end
