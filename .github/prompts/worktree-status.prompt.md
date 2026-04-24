---
description: 'Status of all git worktrees: branch, uncommitted changes, last commit per worktree.'
agent: agent
tools:
  - run_in_terminal
---

```bash
# List all worktrees with their branches
git --no-pager worktree list 2>&1

# Check status of each worktree
git --no-pager worktree list --porcelain 2>&1 | head -40
```

Present a summary table:

| Worktree | Branch | Status | Last Commit |
|----------|--------|--------|-------------|
| ... | ... | clean/dirty | ... |
