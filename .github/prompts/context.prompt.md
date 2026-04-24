---
description: 'Context overview: what is this project, what are the main components, what are the current tasks?'
agent: agent
tools:
  - read_file
  - file_search
  - run_in_terminal
---

Read and summarize:
1. `context/architecture.md` — project structure
2. `context/tasks/todo.md` — current tasks
3. `context/tasks/lessons.md` — recent lessons (last 5 entries)
4. `git --no-pager log --oneline -5 2>&1` — recent history

Present a concise context overview:

```
## Project Context: [project name]

### What this is
[1-2 sentences from architecture.md]

### Active Work
[open todos from todo.md]

### Recent History
[last 5 commits]

### Lessons
[last 3 lessons]
```
