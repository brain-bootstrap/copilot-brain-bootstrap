---
description: 'Git worktree operations: create, list, clean, switch. Enables parallel workstreams without stashing.'
agent: agent
tools:
  - run_in_terminal
  - read_file
argument-hint: '[list | create <branch> | remove <path> | clean]'
---

## Worktree Safety Rules

- Never force-remove a worktree with uncommitted changes
- Always check status before removing: `git --no-pager status --short 2>&1`

## Common Operations

### List worktrees
```bash
git --no-pager worktree list 2>&1
```

### Create
```bash
git worktree add ../worktree-branch-name branch-name 2>&1
```

### Remove (clean worktree)
```bash
git worktree remove ../worktree-branch-name 2>&1
git worktree prune 2>&1
```

### Status of all worktrees
```bash
git --no-pager worktree list --porcelain 2>&1 | head -30
```
