---
description: 'Generate MR/PR description. Reads context/templates.md, runs git diff, verifies build+tests pass, saves to context/tasks/mr-description-*.md.'
mode: agent
tools:
  - read_file
  - create_file
  - run_in_terminal
  - grep_search
argument-hint: '[optional: MR title override]'
---

Read `context/templates.md` and `context/tasks/lessons.md` first.

## Prerequisites (run in order, stop if any fail)

1. `{{BUILD_CMD_ALL}} 2>&1 | tail -10` — must pass
2. `{{TEST_CMD_ALL}} 2>&1 | tail -20` — must pass
3. `{{LINT_CHECK_CMD}} 2>&1 | tail -10` — must pass

If any prerequisite fails: **STOP** — fix before generating the MR description.

## Generate MR Description

1. Get diff stat: `git --no-pager diff main...HEAD --stat 2>&1 | head -30`
2. Get commit messages: `git --no-pager log main...HEAD --oneline 2>&1 | head -20`
3. Get full diff: `git --no-pager diff main...HEAD --color=never 2>&1 | head -200`
4. Fill the MR template from `context/templates.md`

## MR Template Rules

- Base description on the ACTUAL diff, not assumptions
- Distinguish committed changes from any local uncommitted cleanup
- Keep Actual vs Wanted Behavior concise (2-3 lines each)
- Proofs section: exact test count + lint status
- Never reference internal AI tooling in the MR body

## Save to file

Save the result to `context/tasks/mr-description-{{branch-name}}.md`

Present to the user for review — do NOT submit/push autonomously.
