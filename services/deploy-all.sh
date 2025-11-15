#!/usr/bin/env bash
set -euo pipefail

render_template() {
  local env_file="$1"
  local template_path="$2"
  local output_path="$3"
  if [[ ! -f "$template_path" ]]; then
    return
  fi
  if [[ ! -f "$env_file" ]]; then
    echo "WARN: env file $env_file not found; skipping template render for $template_path"
    return
  fi
  python3 - "$env_file" "$template_path" "$output_path" <<'PY'
import sys
from string import Template

env_file, template_path, output_path = sys.argv[1:]

env_vars = {}
with open(env_file, encoding='utf-8') as handle:
    for raw_line in handle:
        line = raw_line.strip()
        if not line or line.startswith('#'):
            continue
        if '=' not in line:
            continue
        key, value = line.split('=', 1)
        env_vars[key] = value

with open(template_path, encoding='utf-8') as handle:
    template = Template(handle.read())

rendered = template.safe_substitute(env_vars)

with open(output_path, 'w', encoding='utf-8') as handle:
    handle.write(rendered)
PY
}

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
    env_file="${stack}/.env"
    env_example="${stack}/.env.example"
    if [[ ! -f "$env_file" && -f "$env_example" ]]; then
      echo "No .env found for $stack; copying defaults"
      cp "$env_example" "$env_file"
    fi
    if [[ "$stack" == "traefik" ]]; then
      mkdir -p "${stack}/letsencrypt"
      if [[ ! -f "${stack}/letsencrypt/acme.json" ]]; then
        echo "Creating traefik ACME store"
        touch "${stack}/letsencrypt/acme.json"
        chmod 600 "${stack}/letsencrypt/acme.json"
      fi
    fi
    if [[ "$stack" == "matrix" ]]; then
      for cfg in homeserver.yaml log.config; do
        cfg_path="${stack}/config/${cfg}"
        if [[ ! -f "$cfg_path" && -f "${cfg_path}.example" ]]; then
          echo "Seeding matrix ${cfg} from example"
          cp "${cfg_path}.example" "$cfg_path"
        fi
      done
    fi
    echo "Deploying $stack"
    docker compose -f "$compose_file" up -d
    if [[ "$stack" == "matrix" ]]; then
      render_template "$env_file" "${stack}/config/homeserver.yaml.example" "${stack}/config/homeserver.yaml"
      if docker volume inspect matrix_synapse-data >/dev/null 2>&1; then
        echo "Ensuring permissions on matrix_synapse-data volume"
        docker run --rm -v matrix_synapse-data:/data alpine:3.20 sh -c "chown -R 991:991 /data" >/dev/null 2>&1 || true
      fi
    fi
  fi
done
