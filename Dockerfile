# Neo4j Community on Railway.
# The upstream image is pinned by version and digest. Caddy is copied in only to
# serve Neo4j Browser and Bolt-over-WebSocket on Railway's single HTTPS port.
FROM caddy:2.11.9-alpine@sha256:003a97808e781aa9f7e75cc2f43d34d461099031faf5e20faefb9f61126836f0 AS caddy

FROM neo4j:2026.10.2-community@sha256:4a2fd4f41ce384aa7d6a74b399f22c202e154f3966119c28a18ed9a500904f5e

COPY --from=caddy /usr/bin/caddy /usr/local/bin/caddy
COPY Caddyfile /etc/caddy/Caddyfile
COPY start.sh /usr/local/bin/railway-start.sh
RUN chmod 0755 /usr/local/bin/railway-start.sh

# Defaults sized for a small Railway service. Override any of them with a
# service variable of the same name (Neo4j's NEO4J_<setting> convention).
ENV NEO4J_server_memory_heap_initial__size=512m \
    NEO4J_server_memory_heap_max__size=1G \
    NEO4J_server_memory_pagecache_size=512m \
    NEO4J_PLUGINS='["apoc"]' \
    NEO4J_server_default__listen__address=:: \
    NEO4J_server_http_listen__address=:7474 \
    NEO4J_server_bolt_listen__address=:7687 \
    NEO4J_dbms_usage__report_enabled=false \
    PORT=8080

EXPOSE 8080 7687
ENTRYPOINT ["tini", "-g", "--", "/usr/local/bin/railway-start.sh"]
