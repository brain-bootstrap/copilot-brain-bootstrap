---
name: writing-skills
description: 'Technical writing skill. Applies clear, concise, evidence-based writing standards to documentation, commit messages, PR descriptions, and comments.'
user-invocable: true
---

# Writing Skills

## Core Principles

1. **Clarity over cleverness** — state what you mean directly
2. **Evidence over assertion** — cite file paths, not opinions
3. **Concise over verbose** — every word must earn its place
4. **Active over passive** — "the service returns X" not "X is returned by the service"

## PR/MR Descriptions

- Lead with impact: "Fixes race condition in UserService causing duplicate emails"
- Include before/after: what was true, what is now true
- List exact proofs: test count, lint status
- No AI meta-commentary ("I updated the code to...")

## Commit Messages

- Format: `type(scope): imperative verb + what`
- Example: `fix(auth): return 401 when JWT is expired`
- Never: "changes", "wip", "fix stuff", "update code"

## Code Comments

- Comment WHY, not WHAT
- ✅ `// Retry 3 times — downstream service has 1s cold start latency`
- ❌ `// Call the service`

## Documentation

- Use headers for scanability
- Use tables for comparisons
- Use code blocks for all command examples
- Test your commands before documenting them

## Anti-patterns

- ❌ "I" as subject — AI perspective leaks in
- ❌ Vague adjectives: "improved", "better", "optimized" (of what? by how much?)
- ❌ Hedge words in instructions: "might", "perhaps", "could consider"
