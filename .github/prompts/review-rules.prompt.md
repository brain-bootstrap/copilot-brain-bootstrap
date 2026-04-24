---
description: 'Review coding rules from claude/rules.md. Use when uncertain about conventions or to refresh AI working standards.'
mode: agent
tools:
  - read_file
---

Read `claude/rules.md` in full and present a concise summary of:

1. The 5 most critical rules for the current task (inferred from context)
2. The working methodology rules (planning, subagents, mistakes)
3. Any rules that are commonly violated (check `claude/tasks/COPILOT_ERRORS.md`)

Format as a quick reference card for the session.
