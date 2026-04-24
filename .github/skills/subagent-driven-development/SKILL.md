---
name: subagent-driven-development
description: 'Delegate complex tasks to subagents to preserve main context. Protocol for splitting work into parallel research, implementation, and review streams.'
user-invocable: true
---

# Subagent-Driven Development Skill

## When to Use Subagents

Use subagents to:
- Research questions without polluting the main context window
- Run parallel streams (explore + implement + review simultaneously)
- Isolate risky explorations (may produce noise)
- Perform long-running analysis tasks

Do NOT use subagents for:
- Simple, single-step operations
- Tasks requiring back-and-forth with the user

## Stream Patterns

### Research Stream (read-only)
Delegate to `@researcher`:
> "Find all callers of UserService.getById and map the data flow. Return: file paths, call chain, and any gotchas."

### Implementation Stream
Run in main context:
- Apply surgical changes after research is complete

### Review Stream (read-only)
Delegate to `@reviewer`:
> "Review the changes in branch X against the 10-point protocol. Return a structured report."

## Coordination Protocol

1. Start all parallel streams simultaneously
2. Wait for all streams to complete before synthesizing
3. Integrate findings in the main context
4. Never start implementation until the research stream returns

## Context Preservation

When context is running low:
1. Run `/caveman-compress` to save state
2. Start a new session with `/resume`
3. The new session picks up from the saved state
