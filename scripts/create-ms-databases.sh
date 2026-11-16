#!/usr/bin/env bash
# Cria databases billing/stock/identity na RDS (mesma instância).
# Uso: CONNECTION_URL="$(terraform -chdir=terraform/environments/prod output -raw connection_url)" \
#        ./scripts/create-ms-databases.sh
set -euo pipefail

URL="${CONNECTION_URL:?CONNECTION_URL obrigatório (postgresql://.../techchallenge)}"

if ! command -v psql >/dev/null 2>&1; then
  echo "psql não encontrado" >&2
  exit 1
fi

# Conecta no database default da URL e cria os três (idempotente).
for db in billing stock identity; do
  psql "$URL" -v ON_ERROR_STOP=1 -tc "SELECT 1 FROM pg_database WHERE datname = '${db}'" | grep -q 1 \
    || psql "$URL" -v ON_ERROR_STOP=1 -c "CREATE DATABASE ${db};"
  echo "ok: ${db}"
done
