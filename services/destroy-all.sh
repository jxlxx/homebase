#!/usr/bin/env bash
set -euo pipefail

cd "$(dirname "$0")"

# Tear down stacks in reverse order of deployment so dependencies stop first.
stacks=(
  excalidraw
  hedgedoc
  matrix
  gitea
  home
  auth
  traefik
)

for stack in "${stacks[@]}"; do
  compose_file="${stack}/docker-compose.yml"
  if [[ ! -f "$compose_file" ]]; then
    echo "Skipping $stack (missing $compose_file)"
    continue
  fi
  echo "Bringing down $stack"
  docker compose -f "$compose_file" down -v "$@"
done

NETWORK_NAME="proxy"
if docker network inspect "$NETWORK_NAME" >/dev/null 2>&1; then
  if docker ps --filter "network=$NETWORK_NAME" --format '{{.ID}}' | grep -q .; then
    echo "Leaving shared $NETWORK_NAME network (still in use)"
  else
    echo "Removing shared $NETWORK_NAME network"
    docker network rm "$NETWORK_NAME" >/dev/null 2>&1 || true
  fi
fi
