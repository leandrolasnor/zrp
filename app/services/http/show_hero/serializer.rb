# frozen_string_literal: true

class Http::ShowHero::Serializer < ActiveModel::Serializer
  attributes :name, :rank, :lat, :lng
end
