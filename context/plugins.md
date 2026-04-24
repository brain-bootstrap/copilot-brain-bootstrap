# MCP Tools & Extensions — {{PROJECT_NAME}}

<!-- BOOTSTRAP: This file is populated during /bootstrap based on detected MCP servers and extensions. -->
<!-- NOTE: These are NOT Claude plugins. For VS Code Copilot, tools work as MCP servers configured in .mcp.json -->

## MCP Tool Status

> For VS Code Copilot, these tools are **MCP servers** registered in `.mcp.json` (workspace root) or VS Code user settings.
> Copilot skills (`.github/skills/`) wrap each tool with optimized prompts.

| Tool              | Status                           | Purpose                           | Skill                |
| ----------------- | -------------------------------- | --------------------------------- | -------------------- |
| CocoIndex         | <!-- installed/not-installed --> | Semantic search (local vectors)   | `/cocoindex-code`    |
| Code Review Graph | <!-- installed/not-installed --> | Change risk analysis (pre-PR)     | `/code-review-graph` |
| Serena            | <!-- installed/not-installed --> | LSP rename/references across repo | `/serena`            |
| Playwright        | <!-- installed/not-installed --> | Browser automation via a11y tree  | `/playwright`        |

## Active MCP Configuration

<!-- Paste relevant sections from .mcp.json below after bootstrap detection -->

```json
// .mcp.json (workspace root) — example
{
  "mcpServers": {
    "cocoindex-code": {
      "command": "uvx",
      "args": [
        "cocoindex-code-mcp-server@latest",
        "--data-dir",
        ".codex/cocoindex"
      ]
    },
    "code-review-graph": {
      "command": "uvx",
      "args": ["code-review-graph@latest"]
    },
    "serena": {
      "command": "uvx",
      "args": ["serena@latest"]
    },
    "playwright": {
      "command": "npx",
      "args": ["@playwright/mcp@latest"]
    }
  }
}
```

## Tool Details

### CocoIndex — Semantic Search

- **Purpose:** Find code by meaning, not exact names. Local vector embeddings — no API key required.
- **When to use:** "Where is rate limiting implemented?", "Find all auth-related files"
- **Config:** Declared in `.mcp.json` · index stored in `.codex/cocoindex/`
- **First run:** `uvx cocoindex-code-mcp-server@latest --data-dir .codex/cocoindex --index`
- **Skill:** `/cocoindex-code`

### Code Review Graph — Change Risk Analysis

- **Purpose:** Pre-PR safety gate. Detects blast radius + risk score (0–100).
- **When to use:** Before any PR · after refactor touching shared code
- **Config:** Declared in `.mcp.json`
- **Install:** `uvx code-review-graph@latest`
- **Skill:** `/code-review-graph`

### Serena — Symbol-Level Refactoring

- **Purpose:** LSP-backed atomic rename/move/find-references across the entire codebase.
- **Config:** `.serena/project.yml` (project-level LSP config) · declared in `.mcp.json`
- **Install:** `uvx serena@latest`
- **Skill:** `/serena`

### Playwright — Browser Automation

- **Purpose:** Navigate, interact with, and snapshot web pages via accessibility tree.
- **Config:** `playwright.config.*` (test runner) · declared in `.mcp.json` for MCP
- **Install:** `npx @playwright/mcp@latest`
- **Skill:** `/playwright`

## Integration Notes

<!-- Add notes about MCP server interactions, known issues, or configuration gotchas -->
