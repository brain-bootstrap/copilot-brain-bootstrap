---
name: issue-triage
description: 'Triage GitHub/GitLab issues. Classify by type, severity, and reproducibility. Add labels, ask for missing information, link related issues.'
user-invocable: true
---

# Issue Triage Skill

## Triage Protocol

For each new issue:

### 1. Classify

| Type | Criteria |
|------|----------|
| 🐛 Bug | Expected behavior differs from actual |
| ✨ Feature | New functionality requested |
| 📚 Docs | Documentation gap or error |
| 🔧 Task | Technical debt, refactor, chore |
| ❓ Question | Needs clarification before classification |

### 2. Severity (for bugs)

| Severity | Criteria |
|----------|----------|
| 🔴 Critical | Data loss, security, production down |
| 🟡 High | Core feature broken, no workaround |
| 🟢 Medium | Feature partially broken, workaround exists |
| ℹ️ Low | Minor, cosmetic, edge case |

### 3. Reproducibility Check

- Can you reproduce with the steps provided?
- If not: ask for more information (version, steps, logs)

### 4. Missing Information Template

```
Thanks for the report! To help us triage this, could you provide:
- [ ] Version: `package@x.y.z` or git commit hash
- [ ] Steps to reproduce (exact commands)
- [ ] Expected behavior
- [ ] Actual behavior + error output
- [ ] Environment: OS, runtime version
```

## Rules

- Never close an issue without explanation
- Always link duplicates before closing
- Tag `needs-info` when waiting for reporter
