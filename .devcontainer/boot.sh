#!/usr/bin/env zsh
set -e
rm -f /api/tmp/pids/server.pid
git pull
bundle exec rake db:migrate:reset
bundle exec rake db:seed
