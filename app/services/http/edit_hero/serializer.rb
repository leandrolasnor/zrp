# frozen_string_literal: true

class Http::EditHero::Serializer < ActiveModel::Serializer
  attributes :name, :rank, :lat, :lng
end
