---
description: 'Caveman commit: think through what should be committed, stage selectively, write a great conventional commit message.'
agent: agent
tools:
  - run_in_terminal
  - read_file
argument-hint: '[optional: commit message hint]'
---

## Caveman Commit Protocol

1. **Survey** what changed: `git --no-pager diff --stat 2>&1 | head -30`
2. **Think** — is everything here intentional? Any debug code? Any unrelated changes?
3. **Stage selectively** — never `git add .` blindly:
   ```bash
   git --no-pager diff --name-only 2>&1 | head -20
   ```
4. **Write a conventional commit message:**
   - Format: `type(scope): imperative verb + what changed`
   - Types: `feat | fix | docs | refactor | test | chore | build | ci | perf | revert`
   - Example: `fix(auth): return 401 when JWT is expired`
5. **Present** the message for approval — do NOT commit automatically
6. **NEVER push** — only local commit

## Good Message Rules

- ✅ Imperative verb: "add", "fix", "remove", "update"
- ✅ Specific: "fix null pointer in UserService.getById"
- ❌ Vague: "changes", "wip", "fix stuff"
- ❌ Past tense: "fixed", "added"
