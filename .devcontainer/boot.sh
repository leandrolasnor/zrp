#!/usr/bin/env zsh
bundle
yarn --cwd ./reacting install
bundle exec rake db:migrate
bundle exec rake db:seed
foreman start -f Procfile.api
