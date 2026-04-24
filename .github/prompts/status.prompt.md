---
description: 'Show project status: branch, uncommitted changes, open todos, test status, recent commits.'
mode: agent
tools:
  - read_file
  - run_in_terminal
---

## Status Report

```bash
# Branch and changes
git --no-pager status 2>&1 | head -20

# Recent commits  
git --no-pager log --oneline -10 2>&1

# Open todos
grep -c '^\- \[ \]' context/tasks/todo.md 2>/dev/null || echo "0 open todos"
```

Read `context/tasks/todo.md` and summarize:
- Branch name
- Uncommitted files count
- In-progress task (if any)
- Next unchecked todo
- Last 3 commits
