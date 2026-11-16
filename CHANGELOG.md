# Changelog

Deployers: read the entry for the version you're updating to before you apply an update. Breaking changes are listed first.

## 2026.10.2-2 (2026-11-16)

- README: Deploy on Railway button for the published template (`neo4j-2`). No change to the image or settings.

## 2026.10.2-1 (2026-11-16)

- First release: Neo4j Community 2026.10.2 (`neo4j:2026.10.2-community@sha256:4a2fd4f41ce384aa7d6a74b399f22c202e154f3966119c28a18ed9a500904f5e`).
- Neo4j Browser and Bolt over WebSocket on the Railway HTTPS domain, through Caddy 2.11.9 (`caddy:2.11.9-alpine@sha256:003a97808e781aa9f7e75cc2f43d34d461099031faf5e20faefb9f61126836f0`).
- Bolt on port 7687 for the private network and the TCP proxy.
- APOC Core 2026.10.2 enabled. Memory defaults: heap 512m–1G, page cache 512m.
- Health check: `/healthz`.
