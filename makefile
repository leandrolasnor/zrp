# makefile
all: prepare run

prepare:
	docker compose up api -d
	docker compose exec api bundle exec rake db:migrate:reset
	docker compose exec api bundle exec rake db:seed

run:
	docker compose up resque sneakers -d
  docker compose exec api foreman start -f Procfile.api

metric:
	docker compose exec api bundle exec rake metric:show
