---
name: pr-triage
description: 'Triage pull requests. Check completeness, tests, changelog, documentation. Flag issues before review. Label and assign.'
user-invocable: true
---

# PR Triage Skill

## PR Completeness Checklist

For each new PR, verify:

- [ ] **Title** follows conventional commits format: `type(scope): message`
- [ ] **Description** — Actual Behavior, Wanted Behavior, Proofs section filled
- [ ] **Tests** — new code has tests
- [ ] **No debug code** — no `console.log`, `pdb.set_trace()`, `binding.pry`
- [ ] **CHANGELOG** updated (for user-facing changes)
- [ ] **No secrets** — grep for API keys, tokens, passwords
- [ ] **Build passes** — check CI status

## Size Assessment

| Size | Lines Changed | Action |
|------|-------------|--------|
| XS | <20 | Fast-track |
| S | 20-100 | Normal review |
| M | 100-500 | Thorough review |
| L | 500-1000 | Request breakdown if possible |
| XL | >1000 | Request breakdown — too large to review safely |

## Feedback Format

```
## PR Triage: [title]

**Size:** M (342 lines)
**Missing:**
- [ ] Tests for the error path in UserService
- [ ] CHANGELOG entry

**Blockers:**
- [ ] Debug console.log on line 42

**Good to review once blockers are resolved.**
```
