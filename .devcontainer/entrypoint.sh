#!/bin/bash
# Substitui variáveis no template e gera o servers.json final
envsubst < /pgadmin4/servers.json.template > /pgadmin4/servers.json

# Executa o entrypoint original do pgAdmin
exec /entrypoint.sh "$@"
