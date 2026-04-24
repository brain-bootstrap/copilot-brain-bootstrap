---
description: 'Migration helper. Generate, review, and apply DB migrations safely with dry-run and rollback support.'
agent: agent
tools:
  - read_file
  - run_in_terminal
  - file_search
argument-hint: '[generate <description> | apply | rollback | status]'
---

Read `context/architecture.md` for the database setup and migration framework.

## Safety Rules

- **NEVER apply migrations to production** without explicit user confirmation
- **ALWAYS dry-run first:** `{{MIGRATE_DRY_CMD}} 2>&1 | tail -20`
- **ALWAYS read the last 2 migrations** before writing a new one — match conventions
- If migration fails, check for partial state before rolling back

## Protocol

### Generate
1. Read 2 existing migrations for conventions
2. Write new migration following exact same patterns
3. Present for review — do NOT apply automatically

### Apply
1. Dry-run: `{{MIGRATE_DRY_CMD}} 2>&1 | tail -10`
2. Apply: `{{MIGRATE_CMD}} 2>&1 | tail -20`
3. Verify: `{{MIGRATE_STATUS_CMD}} 2>&1 | tail -10`

### Rollback
1. Confirm: which migration to roll back to?
2. `{{MIGRATE_ROLLBACK_CMD}} 2>&1 | tail -10`
