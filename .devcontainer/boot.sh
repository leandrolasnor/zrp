#!/usr/bin/env zsh
rm -f /app/tmp/pids/server.pid
git pull
bundle exec rake db:migrate
bundle exec rake db:seed
foreman start
