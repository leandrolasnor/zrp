#!/usr/bin/env zsh
cd /workspaces/zrp
bundle exec rake db:migrate
bundle exec rake db:seed
foreman start -f Procfile.api
