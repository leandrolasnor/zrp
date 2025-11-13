# frozen_string_literal: true

class Http::CreateShortenedUrl::Serializer < ActiveModel::Serializer
  attributes :code, :original_url, :created_at, :updated_at
end
