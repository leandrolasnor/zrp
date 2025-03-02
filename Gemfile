source "https://rubygems.org"
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby "3.2.2"

# Bundle edge Rails instead: gem "rails", github: "rails/rails", branch: "main"
gem "rails", "~> 7.0.8"

# Use sqlite3 as the database for Active Record
gem "sqlite3", "~> 1.4"

# Use the Puma web server [https://github.com/puma/puma]
gem "puma", "~> 5.0"

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

gem 'pg'

gem "paranoia", "~> 2.2"

gem 'meilisearch-rails'

gem 'gruf'

gem 'sneakers'

gem 'dotenv'

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

# Reduces boot times through caching; required in config/boot.rb
gem "bootsnap", require: false

# Use Active Storage variants [https://guides.rubyonrails.org/active_storage_overview.html#transforming-images]
# gem "image_processing", "~> 1.2"

# Use Rack CORS for handling Cross-Origin Resource Sharing (CORS), making cross-origin AJAX possible
gem "rack-cors"

gem "figaro"

group :development, :test do
  gem 'bullet'
  # See https://guides.rubyonrails.org/debugging_rails_applications.html#debugging-with-the-debug-gem
  gem "debug", platforms: %i[mri mingw x64_mingw]
  gem 'factory_bot_rails'
  gem 'faker'
  gem 'grpc-tools'
  gem 'gruf-rspec'
  gem 'rspec'
  gem 'rspec-rails'
  gem 'rswag'
  gem 'rswag-specs'
  gem 'shoulda-matchers'
  gem 'simplecov', require: false
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
  gem 'overmind'
  gem "spring"
end
