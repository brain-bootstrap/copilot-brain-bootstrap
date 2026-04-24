---
description: 'Multi-agent squad planning: break a large feature into parallel workstreams, assign to subagents, coordinate execution.'
agent: agent
tools:
  - read_file
  - replace_string_in_file
  - grep_search
argument-hint: '[feature or epic to decompose]'
---

Read `context/architecture.md` and `context/tasks/lessons.md` first.

## Squad Planning Protocol

1. **Decompose** the feature into independent parallel workstreams
2. **Assign** each stream to an agent role:
   - `@researcher` — exploration and context gathering
   - `@reviewer` — code review
   - `@security-auditor` — security scan
   - Default agent — implementation

3. **Define dependencies** — which streams must complete before others start

4. **Write to todo.md** with parallel tracking:

```markdown
## Epic: [feature name]

### Stream A (parallel) — [description]
- [ ] A1: ...
- [ ] A2: ...

### Stream B (parallel) — [description]  
- [ ] B1: ...

### Stream C (depends on A + B) — [description]
- [ ] C1: ...
```

5. **Present plan** — wait for approval before starting any stream

## Rules

- Each stream must be genuinely independent
- Max 3 parallel streams — don't over-parallelize
- Always designate one "integration" stream that runs last
