#!/usr/bin/env zsh
bundle exec rake db:migrate
bundle exec rake db:seed
foreman start
