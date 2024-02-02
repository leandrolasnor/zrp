# frozen_string_literal: true

class Http::EditHero::Serializer < ActiveModel::Serializer
  attributes :id, :name, :status, :rank, :lat, :lng
end
