---
description: 'Maintenance tasks: update configs, refresh dependencies, run audits, prune stale branches. Regular project hygiene.'
agent: agent
tools:
  - read_file
  - run_in_terminal
  - grep_search
argument-hint: '[audit | deps | branches | full]'
---

## Maintenance Checklist

### Dependencies
- [ ] `npm audit 2>&1 | head -30` — check for HIGH/CRITICAL CVEs
- [ ] `npm outdated 2>&1 | head -20` — check for stale packages

### Branches
- [ ] `git --no-pager branch -v 2>&1 | head -20` — list all branches
- [ ] Identify merged branches that can be deleted (local only — never remote without confirmation)

### Knowledge Layer
- [ ] Are `context/*.md` files still accurate? Check `context/build.md` commands still work
- [ ] Any new lessons learned that aren't in `context/tasks/lessons.md`?

### Placeholder Check
- [ ] `grep -rn '{{' context/ 2>/dev/null | head -10` — any unfilled placeholders?

## Full Maintenance

Run all checks above and report results.
