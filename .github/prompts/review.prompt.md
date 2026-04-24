---
description: 'Full 10-point code review. Reads lessons.md, runs git diff, checks cross-layer consistency, transaction safety, test coverage. Returns structured report with severity markers.'
mode: agent
tools:
  - read_file
  - grep_search
  - file_search
  - list_dir
  - run_in_terminal
argument-hint: '[branch or PR to review — default: current branch vs main]'
---

Read `claude/tasks/lessons.md` and `claude/rules.md` first.

## Review Protocol

1. Get the diff: `git --no-pager diff main...HEAD --stat 2>&1 | head -50`
2. Read each changed file in full
3. Apply the 10-point protocol:

| # | Check | What to look for |
|---|-------|-----------------|
| 1 | Ticket re-read | Every scenario addressed |
| 2 | Diff analysis | Diff is surgical, no unrelated changes |
| 3 | Cross-layer | New fields grep'd across all layers |
| 4 | Enum completeness | All switch/case values handled |
| 5 | Transaction safety | No side effects inside DB transactions |
| 6 | Race conditions | Concurrent flows traced |
| 7 | Test coverage | Every new branch has a test |
| 8 | Pre-existing vs introduced | Warnings classified correctly |
| 9 | Cross-branch safety | No conflicting in-flight changes |
| 10 | Confidence gate | 90+/100 before LGTM |

## Output Format

```
## Review Report — [branch]

### 🔴 Must Fix
### 🟡 Should Fix
### 🟢 Can Skip / Nits

### Confidence Scores
| Check | Score | Notes |
...
| Overall | X/100 | |
```
