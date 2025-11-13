# frozen_string_literal: true

module Create::ShortenedUrl
  class Models::ShortenedUrl
    include Cequel::Record

    key :code, :text
    column :original_url, :text

    delegate :code!, to: :generator

    before_save :code!

    private

    def generator = @generator ||= DomainService::Generator::ShortenedUrl.new(self)
  end
end
