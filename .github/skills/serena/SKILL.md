---
name: serena
description: 'Semantic code navigation via Serena language server. Provides go-to-definition, find-all-references, rename-symbol — semantic operations beyond grep.'
user-invocable: true
---

# Serena Skill

Serena provides language-server-quality code navigation for AI agents.

## When to Use Serena

Use Serena instead of grep when you need:
- **Go-to-definition** — find where a symbol is defined (not just where its name appears)
- **Find-all-references** — semantic references, not text matches
- **Rename-symbol** — safe rename across all callers
- **Call hierarchy** — who calls this function?

## Requirements

- Serena must be configured: check `context/plugins.md` for installation status
- Serena project config: `.serena/project.yml`

## Operations

### Find all references to a symbol
```
@serena find-references UserService
```

### Go to definition
```
@serena go-to-definition UserService.getById
```

### Rename symbol
```
@serena rename UserService.getById getUserById
```

## Fallback (if Serena is not available)

Use grep for text-based search:
```bash
grep -rn 'UserService\.getById' --color=never . 2>/dev/null | head -20
```
