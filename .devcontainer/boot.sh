#!/usr/bin/env zsh
chmod +x ./.devcontainer/start.sh
bundle
yarn --cwd ./reacting install
bundle exec rake db:migrate
bundle exec rake db:seed
foreman start -f Procfile.api
