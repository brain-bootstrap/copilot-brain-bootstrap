---
description: 'Start or manage a local dev server. Check service health, read logs, restart if needed.'
agent: agent
tools:
  - read_file
  - run_in_terminal
argument-hint: '[start | stop | restart | logs | status]'
---

Read `context/build.md` for the dev server command.

## Dev Server Operations

### Start
```bash
# Run in background — read context/build.md for the actual command
{{DEV_CMD}} &
```

### Logs
```bash
# Check process
ps aux 2>/dev/null | grep -E '(node|python|ruby|java|go)' | grep -v grep | head -10
```

### Health check
```bash
# Check if port is listening
lsof -i :{{PORT}} 2>/dev/null | head -5
# or
curl -s http://localhost:{{PORT}}/health 2>/dev/null | head -10
```

## Rules

- Never kill a process that wasn't started by the current session without confirmation
- Use `pkill -f pattern` only with explicit user approval
