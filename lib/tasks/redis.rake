# frozen_string_literal: true

namespace :redis do
  desc "Flush all Redis databases"
  task flushall: :environment do
    puts "Flushing all Redis data..."
    REDIS.with(&:flushall)
    puts "Done!"
  end
end
