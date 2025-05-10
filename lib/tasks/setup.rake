# frozen_string_literal: true

desc "Setup completo do ambiente de desenvolvimento"
task setup: :environment do
  puts "\n== REDIS FLUSHALL =="
  Rake::Task["redis:flushall"].invoke
  puts " Done"

  puts "\n== Clear Resque =="
  Rake::Task["resque:clear"].invoke
  puts " Done"

  puts "\n== Clear Logs =="
  Rake::Task["log:clear"].invoke
  puts " Done"

  puts "\n== Preparing database =="
  Rake::Task["meilisearch:clear_indexes"].invoke
  Rake::Task["db:kill_connections"].invoke
  Rake::Task["db:migrate:reset"].invoke
  puts " Done"

  puts "\n== Building Swagger docs (http://localhost:3000/api-docs) =="
  Rake::Task["rswag:specs:swaggerize"].invoke
  puts " Done"
end
