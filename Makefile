COMPOSE := docker compose --file .devcontainer/docker-compose.yaml --project-name zrp_devcontainer
DEVCONTAINER_CLI ?= devcontainer

.DEFAULT_GOAL := help

.PHONY: help cli up exec test test-api test-socket-client test-socket-server test-react logs _stop-app down reset rebuild

help: ## Lista os alvos disponíveis
	@awk 'BEGIN {FS = ":.*## "} /^[a-zA-Z_-]+:.*## / {printf "  %-18s %s\n", $$1, $$2}' $(MAKEFILE_LIST)

cli: ## Instala o CLI do devcontainer, se necessário
	@command -v $(DEVCONTAINER_CLI) >/dev/null 2>&1 || npm install -g @devcontainers/cli

up: cli ## Sobe o devcontainer
	$(DEVCONTAINER_CLI) up --workspace-folder $(CURDIR)

exec: up ## Execução completa da solução
	$(COMPOSE) exec api ihero

test: test-api test-socket-client test-socket-server test-react ## Roda todos os testes

test-api: up ## Roda os testes da API (RSpec)
	$(COMPOSE) exec -T api rspec

test-socket-client: up ## Roda os testes do socket.io client
	$(COMPOSE) exec -T api corepack yarn test:socket-client

test-socket-server: up ## Roda os testes do socket.io server
	$(COMPOSE) exec -T api corepack yarn test:socket-server

test-react: up ## Roda os testes do React (sem watch)
	$(COMPOSE) exec -T -e CI=true api corepack yarn test:react --watchAll=false

logs: up ## Acompanha os logs dos serviços
	$(COMPOSE) logs -f

_stop-app:
	@$(COMPOSE) exec -T api bin/overmind stop >/dev/null 2>&1 || true

down: _stop-app ## Para os serviços (mantém volumes)
	$(COMPOSE) down -t 30

reset: _stop-app ## Para os serviços e apaga os volumes
	$(COMPOSE) down -v -t 30

rebuild: reset ## Executa reset seguido de up
	$(MAKE) up
