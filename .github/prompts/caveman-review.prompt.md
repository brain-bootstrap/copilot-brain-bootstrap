---
description: 'Caveman review: slow-motion code review of the current diff. Read every changed line, think out loud about each change.'
agent: agent
tools:
  - read_file
  - run_in_terminal
  - grep_search
---

## Caveman Review: Slow-Motion Analysis

Get the diff: `git --no-pager diff --staged --color=never 2>&1 | head -200`

For each changed file, read it in full and ask:

1. **Does this change do what it claims to do?**
2. **Are there any subtle bugs?** (off-by-one, null deref, wrong comparison)
3. **Is this change complete?** (are there callers that also need updating?)
4. **Is this change tested?** (is the new branch covered?)
5. **Is this the simplest correct implementation?**

Think out loud about each question. Don't rush. Quality over speed.

## Output

For each file: a paragraph of thoughts, then a verdict:
- ✅ LGTM
- ⚠️ Minor concern: [description]
- 🔴 Problem: [description]
