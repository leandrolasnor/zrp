# frozen_string_literal: true

namespace :redis do
  desc "Clear Redis data"
  task flushall: :environment do
    puts "Clearing all Redis data..."
    Rails.cache.clear
    puts "Done!"
  end
end
