---
description: 'Update the code search index (CocoIndex or similar). Run after large refactors or when search results seem stale.'
mode: agent
tools:
  - run_in_terminal
  - read_file
---

Read `claude/plugins.md` to check which code indexing tool is configured.

## CocoIndex

```bash
# Check if installed
command -v cocoindex 2>/dev/null || echo "not installed"

# Update index
cocoindex update 2>&1 | tail -20
```

## Notes

- Run this after large refactors or file moves
- If the index is corrupted, delete and rebuild: `cocoindex init`
- Index is stored in `.cocoindex_code/` — do not commit this directory
