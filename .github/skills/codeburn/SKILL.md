---
name: codeburn
description: Use when you want to see token consumption by task type, model, one-shot rate, or cost — observability dashboard for GitHub Copilot sessions. Trigger with /codeburn to analyze session spending.
user-invocable: true
disable-model-invocation: true
---

# Codeburn — Token Cost Observability

Use this skill when you want to understand token consumption patterns for your Copilot sessions.

## What it does

Reads VS Code session data and provides a breakdown of:
- Token usage by task category (refactor, bug-fix, feature, test, docs, review, debug, config, migration, research, security, cleanup, other)
- Cost by model tier
- One-shot rate (tasks completed in a single turn vs multi-turn)
- USD cost estimate for the session or time period

## How to invoke

Type `/codeburn` in chat, optionally with:
- `/codeburn today` — today's sessions only
- `/codeburn week` — last 7 days
- `/codeburn summary` — concise cost overview

## How Copilot uses this skill

1. Reads available session context from VS Code
2. Categorizes requests by task type based on conversation history
3. Estimates token consumption per category
4. Reports top cost drivers and one-shot completion rate

## Task categories

| Category | Trigger words | Cost impact |
|----------|--------------|-------------|
| `feature` | add, implement, create, build | High |
| `refactor` | refactor, clean, restructure | High |
| `bug-fix` | fix, bug, error, broken | Medium |
| `test` | test, spec, coverage | Medium |
| `review` | review, audit, check | Medium |
| `debug` | debug, trace, investigate | High |
| `docs` | docs, comment, readme | Low |
| `research` | what, how, explain | Low |
| `config` | config, setup, install | Low |
| `migration` | migrate, upgrade, update | Medium |
| `security` | security, vuln, auth | High |
| `cleanup` | remove, delete, cleanup | Low |

## Output format

```
━━━ Codeburn Report ━━━━━━━━━━━━━━━━━━━
📅 Period: today (2026-01-01)
🔢 Total requests: 47
💰 Estimated cost: $0.82 (Sonnet tier)

Top categories:
  feature     ████████████ 12 requests (26%)
  debug       ████████     8 requests (17%)
  refactor    ██████       6 requests (13%)

One-shot rate: 72% (34/47 tasks in single turn)
Multi-turn:    28% (avg 3.2 turns/task)
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```

## Cost optimization tips

- High multi-turn rate on `debug` → add more context upfront
- Frequent `research` requests → consolidate into single queries
- High `refactor` cost → scope changes more precisely before starting
