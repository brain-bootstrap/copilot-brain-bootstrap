---
applyTo: '**/*'
---

# General Coding Standards — {{PROJECT_NAME}}

<!-- BOOTSTRAP: Filled during /bootstrap. These instructions apply to every file. -->

## Language & Style

- Match the existing code conventions in every file you touch — read before writing
- No speculative features, no dead code, no unnecessary abstraction
- Comment code only when the WHY is non-obvious; never comment the WHAT

## Error Handling

- Validate at system boundaries only (API handlers, CLI entry points)
- No catch blocks that silently swallow errors
- User-facing errors must never expose internal implementation details

## Testing Standards

- Every new function has at least one test
- Test file mirrors source file structure
- Tests document behavior, not implementation details

## Terminal Safety (applies to all tool calls)

- See `claude/terminal-safety.md` for full rules
- Always use `git --no-pager` — never trigger a pager
- Never open interactive programs (vi, nano, psql bare)
- Always bound output: `| head -N`

## AI Working Rules

- Never skip reading existing files before modifying them
- Never mark tasks complete without running proof (tests pass, logs confirm)
- Never make non-surgical changes — only touch files that the task requires
- Update `claude/tasks/lessons.md` after any correction
