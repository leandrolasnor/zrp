#!/usr/bin/env zsh
set -e
rm -f tmp/pids/server.pid
git pull
rails rswag
exec "$@"
