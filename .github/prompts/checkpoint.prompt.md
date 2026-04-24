---
description: 'Save a checkpoint: commit all progress, record todo state, summarize session for resumption. Use when switching tasks or ending a session.'
mode: agent
tools:
  - read_file
  - run_in_terminal
  - replace_string_in_file
argument-hint: '[optional: checkpoint message]'
---

## Checkpoint Protocol

1. **Assess state:** `git --no-pager status --short 2>&1 | head -20`
2. **Update todo.md:** Mark in-progress items as paused (add `[PAUSED]` prefix)
3. **Stage changed files:** `git add -A 2>&1`
4. **Review what's staged:** `git --no-pager diff --staged --stat 2>&1 | head -20`
5. **Commit:** Present the commit message to the user for approval before committing

## Commit Message Format

```
chore: checkpoint — <brief summary>

Progress:
- <completed item>
- <in-progress item> (paused)

Next: <next action>
```

## Rules

- Never `git push` — only stage and commit locally
- Never commit broken code — run `{{BUILD_CMD_ALL}}` first
- If build fails → fix before checkpointing
