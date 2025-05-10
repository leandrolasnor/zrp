# frozen_string_literal: true

namespace :db do
  desc "Kill PostgreSQL connections to current database"
  task kill_connections: :environment do
    db_name = ActiveRecord::Base.connection.current_database
    pid_column = 'pid'

    sql = <<-SQL.squish
      SELECT pg_terminate_backend(pg_stat_activity.#{pid_column})
      FROM pg_stat_activity
      WHERE datname='#{db_name}' AND pid <> pg_backend_pid();
    SQL

    ActiveRecord::Base.connection.execute(sql)
  end
end
