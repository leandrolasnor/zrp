#!/usr/bin/env zsh
set -e
yarn --cwd ./react install
yarn --cwd ./socket.io/server install
yarn --cwd ./socket.io/client install
bundle
bin/setup
exec "$@"
