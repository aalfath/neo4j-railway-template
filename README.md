# Neo4j on Railway

Railway template for [Neo4j](https://neo4j.com) Community Edition, the open-source graph database with the Cypher query language.

**Deploys:** Neo4j Community **2026.10.2**, built from the official image pinned by digest (`neo4j:2026.10.2-community@sha256:4a2fd4f4…`), with APOC Core enabled and a `/data` volume.

## What you get

| Endpoint | Use it for |
|---|---|
| `https://YOUR-DOMAIN` | Neo4j Browser and the HTTP / Query API. Log in as `neo4j` with `NEO4J_PASSWORD`. |
| `neo4j+s://YOUR-DOMAIN:443` | Bolt over WebSocket, as used by Neo4j Browser (filled in for you). |
| `neo4j://neo4j.railway.internal:7687` | Apps in the same Railway project (private network). |
| `neo4j://YOUR-TCP-PROXY-HOST:PORT` | Drivers, `cypher-shell` and tools outside Railway (TCP proxy, unencrypted). |

Railway's HTTPS domain points at Caddy on `PORT` (8080). Caddy sends WebSocket upgrades to Bolt (7687) and everything else to Neo4j's HTTP port (7474). `/healthz` returns Neo4j's discovery document and is the health check.

## Variables

| Variable | Default | Notes |
|---|---|---|
| `NEO4J_PASSWORD` | generated (`${{secret(32)}}`) | Password of the `neo4j` user. Used only on the **first** start: after that, change it with `ALTER CURRENT USER SET PASSWORD FROM '…' TO '…'` and update the variable to match. |
| `PORT` | `8080` | Port Caddy listens on for the HTTPS domain. |

Any Neo4j setting can be added as a variable using Neo4j's Docker convention: `server.memory.heap.max_size` becomes `NEO4J_server_memory_heap_max__size` (dots become `_`, underscores become `__`). Defaults baked into the image:

- `NEO4J_server_memory_heap_initial__size=512m`, `NEO4J_server_memory_heap_max__size=1G`, `NEO4J_server_memory_pagecache_size=512m`: raise them on larger plans.
- `NEO4J_PLUGINS=["apoc"]`: add more plugins here, for example `["apoc","graph-data-science"]`.

## Updates

Each change to this repo's `main` branch shows up as an "update available" notice in Railway projects deployed from the template. Read [CHANGELOG.md](CHANGELOG.md) before you apply one. Neo4j migrates the store format on start-up when you move to a newer version; back up the volume before major upgrades.

## License

The wrapper in this repo is MIT. Neo4j Community Edition is licensed under GPLv3 by Neo4j, Inc.
