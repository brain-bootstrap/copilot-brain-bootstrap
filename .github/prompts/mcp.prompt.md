---
description: 'MCP server management: list active servers, check status, add/remove MCP configurations.'
mode: agent
tools:
  - read_file
  - file_search
  - run_in_terminal
argument-hint: '[list | status | add <server-name> | remove <server-name>]'
---

## MCP Operations

### List configured servers
Read `.mcp.json` or `mcp.json` at repo root and present the server list.

### Status check
```bash
# Check if MCP servers are running
ps aux 2>/dev/null | grep -i mcp | grep -v grep | head -10
```

### Add a server
1. Read existing `.mcp.json` to understand the format
2. Present the proposed config change to the user for approval
3. Do NOT modify `.mcp.json` without user confirmation

### Available server types
- `stdio` — local subprocess (most common)
- `sse` — server-sent events endpoint

### Notes from context/plugins.md
Read `context/plugins.md` for any project-specific MCP server documentation.
