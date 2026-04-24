---
description: 'Cleanup pass: remove dead code, fix lint violations, delete unused imports, tidy up after a feature. Surgical changes only.'
mode: agent
tools:
  - read_file
  - replace_string_in_file
  - run_in_terminal
  - grep_search
argument-hint: '[optional: specific file or module to clean]'
---

## Cleanup Protocol

1. **Identify candidates:** `{{LINT_CHECK_CMD}} 2>&1 | head -50`
2. **Find dead code:**
   ```bash
   # Unused imports (TypeScript)
   grep -rn 'import.*from' --include='*.ts' . 2>/dev/null | head -20
   ```
3. **Make surgical changes** — one file at a time
4. **Verify after each change:** `{{TEST_CMD_ALL}} 2>&1 | tail -20`

## Rules

- Never remove code that is "probably unused" — verify with grep first
- Never refactor during cleanup — only remove/fix, don't rewrite
- Never change test assertions to make tests pass — fix the code instead
- If a cleanup reveals a real bug, stop and create a ticket
