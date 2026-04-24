---
description: 'Compress context window: summarize conversation progress, save to context/tasks/, prepare for continuation in a new session.'
agent: agent
tools:
  - read_file
  - create_file
  - run_in_terminal
argument-hint: '[optional: output file name]'
---

## Context Compression Protocol

1. **Summarize** the current session:
   - What was accomplished
   - What is in progress
   - What decisions were made
   - What is blocked

2. **Capture todo state** — read `context/tasks/todo.md` for current task list

3. **Write session summary** to `context/tasks/session-YYYY-MM-DD.md`

4. **Prepare handoff message** — what the next session needs to know to continue

## Output Format

```markdown
# Session Summary — [date]

## Accomplished
- ...

## In Progress
- [task] — paused at: [exact step]

## Decisions Made
- [decision]: [rationale]

## Blocked On
- [blocker]: [how to unblock]

## Next Session: Start Here
1. Read context/tasks/todo.md
2. [specific next action]
```
