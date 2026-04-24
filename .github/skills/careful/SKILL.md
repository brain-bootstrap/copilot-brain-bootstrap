---
name: careful
description: 'Careful mode skill. Activates extra safety checks for destructive operations: rm -rf, DROP TABLE, git push --force, production deploys. Forces explicit confirmation.'
user-invocable: true
hooks:
  PreToolUse:
    - type: command
      command: bash .github/hooks/scripts/terminal-safety.sh
---

# Careful Skill

This skill activates extra caution for high-risk operations.

## Blocked Operations (require explicit user confirmation)

| Operation | Risk | Required confirmation |
|-----------|------|----------------------|
| `rm -rf` | Data loss | "I confirm: delete [path]" |
| `DROP TABLE` | Data loss | "I confirm: drop [table]" |
| `DROP DATABASE` | Data loss | "I confirm: drop [database]" |
| `git push --force` | History rewrite | "I confirm: force push to [branch]" |
| `git reset --hard` | Uncommitted work lost | "I confirm: hard reset" |
| Production deploy | Availability risk | "I confirm: deploy to production" |

## Pre-flight Checks

Before any destructive operation:
1. **What exactly will be deleted/overwritten?** List it explicitly.
2. **Is there a backup?** If not, create one.
3. **Is this reversible?** If not, double-confirm.

## Confirmation Format

When blocking an operation, output:
```
⛔ CAREFUL: [operation] is destructive and irreversible.
This will: [exact description of what will happen]
To proceed, say: "I confirm: [action]"
```
