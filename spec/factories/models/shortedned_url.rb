# frozen_string_literal: true

class ShortenedUrl
  include Cequel::Record

  key :code, :text
  column :original_url, :text
end
