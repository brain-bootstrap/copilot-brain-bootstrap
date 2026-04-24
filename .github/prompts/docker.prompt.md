---
description: 'Docker and container operations. Build, run, inspect, debug containers. Manages docker-compose services.'
mode: agent
tools:
  - read_file
  - run_in_terminal
  - file_search
argument-hint: '[build | up | down | logs | exec | inspect]'
---

## Docker Safety Rules

- Never run containers in privileged mode unless explicitly needed
- Never hardcode secrets in Dockerfiles — use build args or secrets
- Always tag images: never use `latest` in production configs

## Common Operations

### Docker Compose
```bash
docker compose up -d 2>&1 | tail -20
docker compose down 2>&1 | tail -10
docker compose logs --no-color --tail=50 service-name 2>&1
docker compose ps 2>&1
```

### Build
```bash
docker build -t image-name:tag . 2>&1 | tail -30
```

### Inspect a container
```bash
docker exec container-name env 2>&1 | grep -v SECRET | head -20
docker inspect container-name 2>&1 | head -50
```

### Debug
```bash
docker logs --no-color --tail=50 container-name 2>&1
```

## Rules

- Always check `claude/architecture.md` for service names before docker exec
- Use `--no-color` on all docker log commands
