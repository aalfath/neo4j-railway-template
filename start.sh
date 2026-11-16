#!/bin/bash
# Starts Neo4j (through the image's own entrypoint) and Caddy side by side.
# If either one exits, the container exits so Railway restarts it.
set -euo pipefail

if [ -z "${NEO4J_AUTH:-}" ]; then
  if [ -z "${NEO4J_PASSWORD:-}" ]; then
    echo "NEO4J_PASSWORD is not set. Set it (8+ characters) before starting Neo4j." >&2
    exit 1
  fi
  if [ "${#NEO4J_PASSWORD}" -lt 8 ]; then
    echo "NEO4J_PASSWORD must be at least 8 characters." >&2
    exit 1
  fi
  export NEO4J_AUTH="neo4j/${NEO4J_PASSWORD}"
fi
unset NEO4J_PASSWORD

export PORT="${PORT:-8080}"

# Neo4j Browser reads its default connect URL from the advertised Bolt address.
# On Railway, point it at the public HTTPS domain (Bolt over WebSocket on 443).
if [ -z "${NEO4J_server_bolt_advertised__address:-}" ] && [ -n "${RAILWAY_PUBLIC_DOMAIN:-}" ]; then
  export NEO4J_server_bolt_advertised__address="${RAILWAY_PUBLIC_DOMAIN}:443"
fi

caddy run --config /etc/caddy/Caddyfile --adapter caddyfile &
/startup/docker-entrypoint.sh neo4j &

wait -n
status=$?
echo "A process exited (status ${status}); stopping the container." >&2
exit "${status}"
