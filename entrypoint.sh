#!/usr/bin/env zsh
set -e

# Remove a potentially pre-existing server.pid for Rails.
rm -f tmp/pids/server.pid
git pull
# Then exec the container's main process (what's set as CMD in the Dockerfile).
exec "$@"
