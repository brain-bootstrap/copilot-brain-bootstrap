---
description: 'Clean up stale git worktrees. Checks for merged/abandoned branches and removes safely.'
agent: agent
tools:
  - run_in_terminal
  - read_file
---

## Clean Worktrees Protocol

1. List all worktrees: `git --no-pager worktree list 2>&1`
2. For each non-main worktree:
   - Check if the branch is merged: `git --no-pager branch --merged main 2>&1`
   - Check for uncommitted changes in the worktree
3. Present a list of safe-to-remove worktrees
4. Wait for user confirmation before removing any

## Rules

- NEVER remove a worktree with uncommitted work
- NEVER remove the main worktree
- Always `git worktree prune` after removing to clean up stale references
