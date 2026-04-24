# Copilot Recurring Errors — {{PROJECT_NAME}}

> Patterns that keep causing problems. Check this before starting any session. If Copilot repeats a mistake, add it here immediately.

<!-- Format: ## ERROR-NNN — <pattern>\n**Symptom:** ...\n**Root cause:** ...\n**Rule:** ... -->

## How to Use This File

When Copilot makes a mistake that you correct, add an entry here.
The `session-context` hook injects the last 5 lessons + open todos at session start.

Example entry:

```
## ERROR-001 — Missing --no-pager on git commands
**Symptom:** Terminal hangs after git log/show/diff
**Root cause:** git opens a pager (less/more) by default
**Rule:** Always use: git --no-pager log, git --no-pager diff, etc.
```
