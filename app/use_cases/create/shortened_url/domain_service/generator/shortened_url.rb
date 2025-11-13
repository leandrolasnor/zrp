# frozen_string_literal: true

require 'digest'
module Create::ShortenedUrl
  class DomainService::Generator::ShortenedUrl
    extend Dry::Initializer

    param :shortened_url, type: Types::Instance(Models::ShortenedUrl), reader: :private
    option :length, type: Types::Integer, default: -> { 7 }, reader: :private
    option :salt,
           type: Types::String,
           default: -> { ENV.fetch('RAILS_MASTER_KEY', SecureRandom.hex(32)) },
           reader: :private
    option :number,
           type: Types::Integer,
           default: -> { REDIS.with { it.incr('shortened_url:number') } },
           reader: :private
    option :hash,
           type: Types::String,
           default: -> { Digest::SHA256.hexdigest("#{salt}#{number}") },
           reader: :private
    option :CHARSET,
           type: Types::Instance(Array),
           default: -> { '0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ'.chars },
           reader: :private

    def code! = shortened_url.code = generate_short_code

    private

    def generate_short_code
      @generate_short_code ||= hash.bytes.inject('') do |base62, byte|
        base62 << CHARSET[byte % CHARSET.size]
        break base62 if base62.length >= length

        base62
      end
    end
  end
end
