---
name: receiving-code-review
description: 'Skill for processing code review feedback. Triages review comments by severity, creates fix tasks, applies changes systematically, and responds to reviewers.'
user-invocable: true
---

# Receiving Code Review Skill

## Protocol

### 1. Triage review comments

Read all comments and classify:

| Comment | Severity | Actionable? | Response |
|---------|----------|-------------|---------|
| "This will NPE if..." | 🔴 Must Fix | Yes | Fix immediately |
| "Consider using X instead" | 🟡 Should Consider | Yes | Evaluate and respond |
| "Nit: rename this" | 🟢 Nit | Optional | Fix if easy, defer if not |
| "Why did you..." | 💬 Question | Answer | Respond in comment |

### 2. For each Must Fix and Should Fix

1. Understand the concern fully before making changes
2. If unclear: ask for clarification, don't guess
3. Make the surgical fix
4. Run tests to confirm no regression
5. Respond in the review: "Fixed in [commit]"

### 3. Respond to questions

- Answer with evidence from the codebase
- If the reviewer has a point, acknowledge it and adjust

### 4. Nits (optional)

Fix nits only if they are trivially correct. If a nit would require significant refactoring, add a ticket instead.

## Anti-patterns

- ❌ Blindly applying all suggestions without evaluating them
- ❌ Arguing against must-fix comments — understand and fix
- ❌ Fixing nits that change more than 3 lines
- ❌ Not responding to reviewer comments
