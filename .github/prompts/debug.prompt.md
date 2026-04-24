---
description: 'Root cause debugging: 4-phase protocol (Observe, Hypothesize, Trace, Verify). Iron Law: no fix without root cause. No more "try this and see".'
agent: agent
tools:
  - read_file
  - grep_search
  - file_search
  - list_dir
  - run_in_terminal
argument-hint: '[describe the bug or paste the error]'
---

Read `context/tasks/lessons.md` first — check if this bug pattern has been seen before.

## Iron Law: NO FIX WITHOUT ROOT CAUSE

Do not attempt a fix until you can state the root cause in one sentence:
> "This bug is caused by X in file Y at line Z because W."

## Phase 1 — Observe

Collect all available evidence:
1. Run the failing command/test and capture full output
2. Check recent git log: `git --no-pager log --oneline -10 2>&1`
3. Check if tests pass: `{{TEST_CMD_ALL}}` (from `context/build.md`)
4. Identify: what changed recently that could have introduced this?

## Phase 2 — Hypothesize

Based on evidence, form 2-3 candidate root causes. Rank by likelihood.

## Phase 3 — Trace Backwards

For each hypothesis:
1. Find the entry point (API handler, test, CLI)
2. Trace the call chain to the failure point
3. Search for the pattern: `grep -rn 'pattern' --color=never 2>&1 | head -20`
4. Eliminate hypotheses with evidence, not intuition

## Phase 4 — Fix & Verify

1. State the confirmed root cause
2. Write the fix (surgical — only touch the root cause)
3. Run tests to confirm fix
4. Confirm no regression: re-run the full test suite

## Anti-patterns

- ❌ "Let's try changing X and see if it helps" — never speculative
- ❌ Fixing symptoms without tracing to root cause
- ❌ Changing >3 files for a bug fix without justification
