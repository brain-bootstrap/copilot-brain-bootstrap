---
description: 'Run lint + format checks. Read claude/build.md for lint commands. Report violations. Auto-fix if requested.'
mode: agent
tools:
  - read_file
  - run_in_terminal
argument-hint: '[optional: --fix to auto-fix violations]'
---

Read `claude/build.md` first for the exact lint and format commands.

## Lint Protocol

1. Run: `{{LINT_CHECK_CMD}} 2>&1 | head -50`
2. Report:
   - ✅ 0 violations
   - ⚠️ N violations — list them grouped by severity

## Auto-fix (if --fix provided)

1. Run: `{{LINT_FIX_CMD}} 2>&1 | head -30`
2. Re-run check to confirm 0 violations remain
3. Report changed files: `git --no-pager diff --name-only 2>&1`

## Rules

- Never auto-fix unless explicitly asked with --fix argument
- Never ignore violations — if a rule is wrong, discuss changing the config, don't suppress
