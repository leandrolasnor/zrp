build:
	npm install -g @devcontainers/cli
	devcontainer up --workspace-folder .

exec: build
	docker exec -it zrp.api ihero

down:
	docker compose --file './.devcontainer/docker-compose.yml' --project-name 'zrp_devcontainer' down -v
