# Plugins & Integrations — {{PROJECT_NAME}}

<!-- BOOTSTRAP: This file is populated during /bootstrap based on detected plugins. -->

## Available Plugin Categories

| Category        | Plugin            | Status                           | Purpose                     |
| --------------- | ----------------- | -------------------------------- | --------------------------- |
| Code indexing   | CocoIndex         | <!-- installed/not-installed --> | Structural code queries     |
| Knowledge graph | Code Review Graph | <!-- installed/not-installed --> | Architectural visualization |
| Language server | Serena            | <!-- installed/not-installed --> | Semantic code navigation    |
| Testing         | Playwright        | <!-- installed/not-installed --> | E2E browser automation      |

## Plugin Configuration

### CocoIndex (Structural Code Queries)

- Config: `.cocoindex_code/settings.yml`
- Purpose: Query your codebase structure — find all callers of a function, trace a data flow, understand module boundaries.
- Skill: `/cocoindex-code`

### Code Review Graph (Architecture Visualization)

- Purpose: Generate dependency graphs, identify circular dependencies, spot architectural drift.
- Skill: `/code-review-graph`

### Serena (Semantic Code Navigation)

- Config: `.serena/project.yml`
- Purpose: Go-to-definition, find-all-references, rename-symbol — semantic operations beyond grep.
- Skill: `/serena`

### Playwright (E2E Testing)

- Purpose: Browser automation, visual regression testing, accessibility testing.
- Skill: `/playwright`

## MCP Servers

<!-- Document active MCP servers from .mcp.json -->
<!-- | Server | Key | Purpose | -->

## Integration Notes

<!-- Add notes about plugin interactions, known issues, or configuration gotchas -->
