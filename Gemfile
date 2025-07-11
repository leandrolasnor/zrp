# frozen_string_literal: true

source "https://rubygems.org"
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby "3.4.2"

# Bundle edge Rails instead: gem "rails", github: "rails/rails", branch: "main"
gem "rails", "~> 8.0.2"

gem "rake", "~> 13.2.1"

# Use sqlite3 as the database for Active Record
gem "sqlite3", ">= 2.1"

# Use the Puma web server [https://github.com/puma/puma]
gem "puma", ">= 5.0"

gem 'active_model_serializers'

gem 'dry-container'

gem 'dry-transaction'

gem 'dry-monads'

gem 'dry-initializer'

gem 'dry-validation'

gem 'redis'

gem 'redis-namespace'

gem 'connection_pool'

gem 'kaminari'

gem 'geocoder'

gem 'resque', require: 'resque/server'

gem 'resque-scheduler'

gem 'activejob-uniqueness'

gem 'pg'

gem "paranoia"

gem 'meilisearch-rails'

gem 'gruf'

gem 'sneakers'

gem 'dotenv'

gem 'overmind'

gem 'aasm'

# Build JSON APIs with ease [https://github.com/rails/jbuilder]
# gem "jbuilder"

# Use Redis adapter to run Action Cable in production
# gem "redis", "~> 4.0"

# Use Kredis to get higher-level data types in Redis [https://github.com/rails/kredis]
# gem "kredis"

# Use Active Model has_secure_password [https://guides.rubyonrails.org/active_model_basics.html#securepassword]
# gem "bcrypt", "~> 3.1.7"

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem "tzinfo-data", platforms: %i[mingw mswin x64_mingw jruby]

# Use the database-backed adapters for Rails.cache, Active Job, and Action Cable
gem "solid_cable"
gem "solid_cache"
gem "solid_queue"

# Reduces boot times through caching; required in config/boot.rb
gem "bootsnap", require: false

# Deploy this application anywhere as a Docker container [https://kamal-deploy.org]
gem "kamal", require: false

# Add HTTP asset caching/compression and X-Sendfile acceleration to Puma [https://github.com/basecamp/thruster/]
gem "thruster", require: false

# Use Active Storage variants [https://guides.rubyonrails.org/active_storage_overview.html#transforming-images]
# gem "image_processing", "~> 1.2"

# Use Rack CORS for handling Cross-Origin Resource Sharing (CORS), making cross-origin AJAX possible
gem "rack-cors"

group :development, :test do
  gem 'benchmark'
  gem 'bullet'
  # Static analysis for security vulnerabilities [https://brakemanscanner.org/]
  gem "brakeman", require: false
  # See https://guides.rubyonrails.org/debugging_rails_applications.html#debugging-with-the-debug-gem
  gem "debug", platforms: %i[mri windows], require: "debug/prelude"
  gem 'factory_bot_rails'
  gem 'faker'
  gem 'grpc-tools'
  gem 'gruf-rspec'
  gem 'ostruct'
  gem 'parallel_tests'
  gem 'rspec'
  gem 'rspec-rails'
  gem 'rswag'
  gem 'rswag-specs'
  # Omakase Ruby styling [https://github.com/rails/rubocop-rails-omakase/]
  gem "rubocop-rails-omakase", require: false
  gem 'shoulda-matchers'
  gem 'sse-client'
  gem 'timecop'
  gem 'webmock'
end

group :development do
  gem 'rubocop', require: false
  gem 'rubocop-inflector', require: false
  gem 'rubocop-performance', require: false
  gem 'rubocop-rails', require: false
  gem 'rubocop-rspec', require: false
  gem 'rubocop-rspec_rails', require: false
  # Speed up commands on slow machines / big apps [https://github.com/rails/spring]
  gem "spring"
end

group :test do
  gem 'simplecov', require: false
  gem 'simplecov-tailwindcss', require: false
end
