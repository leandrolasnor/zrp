#!/usr/bin/env zsh
cd /workspaces/zrp
bundle
bundle exec rake db:migrate
bundle exec rake db:seed
foreman start
