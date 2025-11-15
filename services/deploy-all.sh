#!/usr/bin/env bash
set -euo pipefail

cd "$(dirname "$0")"
NETWORK_NAME="proxy"

if ! docker network inspect "$NETWORK_NAME" >/dev/null 2>&1; then
  echo "Creating shared $NETWORK_NAME network"
  docker network create "$NETWORK_NAME"
fi

stacks=(
  traefik
  auth
  home
  gitea
  matrix
  hedgedoc
  excalidraw
)

for stack in "${stacks[@]}"; do
  compose_file="${stack}/docker-compose.yml"
  if [[ -f "$compose_file" ]]; then
    echo "Deploying $stack"
    docker compose -f "$compose_file" up -d
  fi
done
