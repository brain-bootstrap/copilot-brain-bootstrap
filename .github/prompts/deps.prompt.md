---
description: 'Check, audit, and upgrade dependencies. Run security audit, check outdated packages, review before updating.'
agent: agent
tools:
  - read_file
  - run_in_terminal
  - grep_search
argument-hint: '[audit | outdated | upgrade <package> | all]'
---

Read `context/cve-policy.md` first for the security audit process.

## Dependency Operations

### Security Audit
```bash
npm audit --json 2>&1 | head -100
# or
pip-audit 2>&1 | head -50
# or
cargo audit 2>&1 | head -50
```

### Check Outdated
```bash
npm outdated 2>&1 | head -30
# or
pip list --outdated 2>&1 | head -30
```

### Upgrade Protocol

1. Check the changelog for breaking changes
2. Upgrade one package at a time for major versions
3. Run `{{TEST_CMD_ALL}} 2>&1 | tail -20` after each upgrade
4. Re-run security audit to confirm 0 HIGH/CRITICAL

## Rules

- Never auto-upgrade all packages at once
- Never merge a security PR without running tests first
- Never pin transitive dependencies unless there's no other option
