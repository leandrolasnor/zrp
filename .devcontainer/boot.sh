#!/usr/bin/env zsh
yarn --cwd ./reacting install
yarn --cwd ./socket.io/server install
yarn --cwd ./socket.io/client install
bundle
bundle exec rake db:migrate
bundle exec rake db:seed
