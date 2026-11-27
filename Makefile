COMPOSE := docker compose --file .devcontainer/docker-compose.yaml --project-name zrp_devcontainer
DEVCONTAINER_CLI ?= devcontainer

.DEFAULT_GOAL := help

.PHONY: help cli up exec test test-api test-socket-client test-socket-server test-react logs down reset rebuild

help: ## Lista os alvos disponíveis
	@awk 'BEGIN {FS = ":.*## "} /^[a-zA-Z_-]+:.*## / {printf "  %-18s %s\n", $$1, $$2}' $(MAKEFILE_LIST)

cli: ## Instala o CLI do devcontainer, se necessário
	@command -v $(DEVCONTAINER_CLI) >/dev/null 2>&1 || npm install -g @devcontainers/cli

up: cli ## Sobe o devcontainer e todos os serviços
	$(DEVCONTAINER_CLI) up --workspace-folder $(CURDIR)
	$(COMPOSE) up -d

exec: up ## Abre um shell no container da api
	$(COMPOSE) exec api zsh

test: test-api test-socket-client test-socket-server test-react ## Roda todos os testes

test-api: up ## Roda os testes da API (RSpec)
	$(COMPOSE) exec -T api rspec

test-socket-client: up ## Roda os testes do socket.io client
	$(COMPOSE) exec -T api corepack yarn test:socket-client

test-socket-server: up ## Roda os testes do socket.io server
	$(COMPOSE) exec -T api corepack yarn test:socket-server

test-react: up ## Roda os testes do React (sem watch)
	$(COMPOSE) exec -T -e CI=true api corepack yarn test:react --watchAll=false

logs: up ## Abre a UI de logs (Dozzle) em http://localhost:8888
	@echo "Dozzle: http://localhost:8888"
	@command -v xdg-open >/dev/null 2>&1 && xdg-open http://localhost:8888 >/dev/null 2>&1 || true

down: ## Para os serviços (mantém volumes)
	$(COMPOSE) down -t 30

reset: ## Para os serviços e apaga os volumes
	$(COMPOSE) down -v -t 30

rebuild: reset ## Executa reset seguido de up
	$(MAKE) up
