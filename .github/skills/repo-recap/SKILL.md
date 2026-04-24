---
name: repo-recap
description: 'Generate a project recap: what is this repo, what are the main components, what is the current state of work.'
user-invocable: true
---

# Repo Recap Skill

## Protocol

Generate a structured recap of the repository by reading:

1. `context/architecture.md` — structure and services
2. `context/tasks/todo.md` — current work
3. `context/tasks/lessons.md` — recent lessons
4. `git --no-pager log --oneline -10` — recent history
5. `git --no-pager status --short` — current state

## Output Format

```markdown
# Repo Recap — [project name]

## What is this?
[2-3 sentences describing the project]

## Architecture
| Component | Purpose |
|-----------|---------|
| ... | ... |

## Current Work
[Active tasks from todo.md]

## Recent History
[Last 5 commits]

## Known Issues / Lessons
[Last 3 lessons from lessons.md]

## Health
- Build: [unknown/passing/failing]
- Tests: [unknown/passing/failing]
- Open todos: [count]
```
