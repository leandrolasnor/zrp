# frozen_string_literal: true

module Create::ShortenedUrl
  class Contract < ApplicationContract
    URL_REGEX = %r{\Ahttps?://.+\z}i

    params do
      required(:original_url).filled(:string)
    end

    rule(:original_url) do
      unless value.match?(URL_REGEX)
        key.failure(:invalid_url_format)
      end
    end
  end
end
