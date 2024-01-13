#!/usr/bin/env zsh
chmod +x ./.devcontainer/start.sh
bundle
yarn --cwd ./reacting install
yarn --cwd ./socket.io/server install
yarn --cwd ./socket.io/client install
bundle exec rake db:migrate
bundle exec rake db:seed
foreman start
