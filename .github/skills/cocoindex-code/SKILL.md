---
name: cocoindex-code
description: 'Structural code queries via CocoIndex. Find all callers of a function, trace data flows, understand module boundaries. Better than grep for semantic queries.'
user-invocable: true
---

# CocoIndex Code Skill

CocoIndex enables structural code queries that are impossible with text search.

## Requirements

Check `context/plugins.md` for CocoIndex installation status.
Config: `.cocoindex_code/settings.yml`

## When to Use CocoIndex vs grep

| Query type | Use |
|------------|-----|
| Find all callers of a function | CocoIndex |
| Find all files importing a module | CocoIndex |
| Find all implementations of an interface | CocoIndex |
| Find text in files | grep |
| Find files by name | file_search |

## Operations

### Update index (run after large refactors)
```bash
cocoindex update 2>&1 | tail -10
```

### Query examples
```bash
# Find all callers of a function
cocoindex query 'callers of UserService.getById' 2>&1 | head -20

# Find all imports of a module
cocoindex query 'imports of ./auth/middleware' 2>&1 | head -20
```

## Fallback

If CocoIndex is not available, use grep:
```bash
grep -rn 'UserService\.getById\|new UserService' --color=never . 2>/dev/null | head -20
```
