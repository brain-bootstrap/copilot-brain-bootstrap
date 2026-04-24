---
name: root-cause-trace
description: 'Root cause analysis skill. Iron Law: never fix a bug without stating the root cause. 5-step: Observe, Hypothesize, Trace Backwards, Isolate, Verify.'
user-invocable: true
---

# Root Cause Trace Skill

## Iron Law

**Never fix a bug without stating the root cause in one sentence.**

> "This bug is caused by X in file Y at line Z because W."

If you cannot state this, you have not found the root cause yet.

## 5-Step Protocol

### Step 1: Observe

Collect all available evidence without filtering:
- Run the failing command/test — capture full output
- Check git log: `git --no-pager log --oneline -10 2>&1`
- What changed recently? `git --no-pager diff HEAD~5 --stat 2>&1`

### Step 2: Hypothesize

Form 2-3 candidate root causes ranked by likelihood.  
Do not commit to one until you have evidence.

### Step 3: Trace Backwards

Starting from the failure point, trace backwards:
- What called the failing code?
- What state was passed in?
- Where was that state created?

Use grep to follow the chain:
```bash
grep -rn 'function_name' --color=never . 2>/dev/null | head -20
```

### Step 4: Isolate

Eliminate hypotheses one by one with evidence. When only one remains, that is the root cause.

### Step 5: Verify

1. State the root cause
2. Apply a surgical fix (≤3 files for a bug)
3. Run tests to confirm the bug is gone
4. Run full test suite to confirm no regression

## Anti-patterns

- ❌ "Let's try changing X and see if it helps"
- ❌ Fixing symptoms without tracing to root cause
- ❌ Changing >3 files without justification
- ❌ Skipping verification after fix
