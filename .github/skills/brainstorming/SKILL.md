---
name: brainstorming
description: 'Brainstorming skill. HARD GATE before implementation. Forces structured option analysis before any code is written.'
user-invocable: true
disable-model-invocation: false
---

# Brainstorming Skill

## HARD GATE

**No code until brainstorm is complete and the user has approved an approach.**

## Protocol

### 1. Problem Restatement

Restate the problem in your own words. Ask the user to confirm understanding before proceeding.

### 2. Known Facts

List what you know from the codebase (search for evidence — no guessing):
- What patterns already exist?
- What constraints apply?
- What has been tried before? (check `context/tasks/lessons.md`)

### 3. Options

Generate 2-4 different approaches. For each:

| Option | Description | Pros | Cons | Risk |
|--------|-------------|------|------|------|
| A | ... | ... | ... | ... |
| B | ... | ... | ... | ... |

### 4. Recommendation

Pick one option with justification. Be explicit about why the others were rejected.

### 5. Approval Gate

> "Brainstorm complete. Recommend Option [X] because [reason]. Shall I proceed?"

**Do not proceed until the user explicitly approves.**

## Anti-patterns

- ❌ Jumping to "the obvious solution" without alternatives
- ❌ Proposing approaches that contradict existing patterns (search first)
- ❌ Skipping the approval gate
