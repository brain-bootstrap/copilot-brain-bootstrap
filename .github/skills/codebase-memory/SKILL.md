---
name: codebase-memory
description: 'Maintain a persistent code index and summary. Track important functions, patterns, and architectural decisions for fast future retrieval.'
user-invocable: true
---

# Codebase Memory Skill

## Purpose

Create and maintain a persistent, queryable memory of the codebase structure — so you don't have to re-read the same files every session.

## Memory Artifacts

| File | Purpose |
|------|---------|
| `claude/architecture.md` | Service catalog, directory layout |
| `claude/decisions.md` | Architectural decisions (ADRs) |
| `claude/tasks/lessons.md` | Accumulated wisdom from past work |

## Update Protocol

After any significant code change:

1. **Update architecture.md** if new services/modules were added
2. **Update decisions.md** if an architectural decision was made
3. **Update lessons.md** if a mistake was made or a lesson was learned

## Search Protocol

Before reading any file from scratch:

1. Check `claude/architecture.md` for the relevant service/module
2. Use grep to find specific patterns: `grep -rn 'pattern' --color=never . 2>/dev/null | head -20`
3. Only then open the specific file

## Index Update

After large refactors, run `/update-code-index` to refresh the code search index.
