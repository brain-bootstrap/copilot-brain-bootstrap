---
description: 'Restore full session context. Reads todo.md, lessons.md, architecture.md, git log. Summarizes where we left off and next actions.'
mode: agent
tools:
  - read_file
  - run_in_terminal
  - grep_search
---

## Context Restoration Protocol

1. Read `context/tasks/todo.md` — current task state
2. Read `context/tasks/lessons.md` — recent lessons (last 10 lines)
3. Read `context/architecture.md` — system context
4. Run `git --no-pager log --oneline -10 2>&1` — recent commits
5. Run `git --no-pager status --short 2>&1 | head -20` — uncommitted changes

## Output Format

```
## Resumed Session Context

**Branch:** <branch>
**Uncommitted changes:** <count> files

### In Progress
<current task from todo.md>

### Next Steps
1. <next unchecked item from todo.md>
2. ...

### Recent Lessons (don't repeat these mistakes)
- <last 3 lessons>
```

After presenting context, ask: "Ready to continue?" — wait for confirmation before taking action.
