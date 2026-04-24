---
description: 'Plan a task: read lessons + architecture, write a checkable todo list to context/tasks/todo.md, challenge the plan adversarially, then present for approval.'
agent: agent
tools:
  - read_file
  - replace_string_in_file
  - grep_search
  - file_search
  - list_dir
argument-hint: '[task description]'
---

Read `context/tasks/lessons.md`, `context/architecture.md`, and `context/rules.md` first.

## Planning Protocol

1. **Understand the task** — Restate what was asked in your own words. Confirm scope.
2. **Research first** — Identify the relevant files, services, and patterns that the task touches.
3. **Identify risks** — What could go wrong? What patterns have bitten us before (lessons.md)?
4. **Write the plan** — Create a checkable todo list in `context/tasks/todo.md`.
5. **Challenge the plan** — Ask: What assumptions am I making? What edge cases am I missing?
6. **Present for approval** — Do NOT start implementing until the user approves.

## Plan Format (write to context/tasks/todo.md)

```markdown
## Plan: [task name]

### Context
[2-3 lines: why this task exists, what it changes]

### Files to touch
- `path/to/file.ts` — [reason]

### Steps
- [ ] Step 1: ...
- [ ] Step 2: ...
- [ ] Step 3: ...
- [ ] Verify: run tests + lint

### Risks
- [risk]: [mitigation]
```

## Rules

- Never start implementing before the user says "proceed" or equivalent
- Never write vague steps like "update the service" — be specific about which function/class/field
- Never skip the verification step
