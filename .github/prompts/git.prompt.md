---
description: 'Git operations helper. Smart commit (conventional commits), branch management, worktree operations. Never pushes autonomously.'
agent: agent
tools:
  - run_in_terminal
  - read_file
argument-hint: '[commit | branch | log | status | stash | worktree]'
---

## Git Safety Rules

- **NEVER `git push` autonomously** — always present the summary and wait for user confirmation
- **NEVER `git push --force`** — requires explicit user request and confirmation
- **NEVER `git reset --hard`** — requires explicit user request
- Always use `git --no-pager` to prevent pager hangs

## Common Operations

### Commit (conventional)
```bash
git --no-pager diff --staged --stat 2>&1 | head -20
git --no-pager status --short 2>&1 | head -20
# Then: git commit -m "type(scope): message"
```
Types: `feat | fix | docs | refactor | test | chore | build | ci | perf | revert`

### Log
```bash
git --no-pager log --oneline -20 2>&1
```

### Branch
```bash
git --no-pager branch -v 2>&1 | head -20
```

### Stash
```bash
git --no-pager stash list 2>&1 | head -10
```

### Status
```bash
git --no-pager status --short 2>&1 | head -30
```
