---
description: 'Generate or triage a GitHub/GitLab issue from a bug report or feature request. Uses context/templates.md ticket format.'
agent: agent
tools:
  - read_file
  - run_in_terminal
  - grep_search
argument-hint: '[describe the bug or feature]'
---

Read `context/templates.md` for the ticket template format.

## Ticket Generation Protocol

1. **Classify:** Bug | Story | Task
2. **Reproduce (for bugs):** Run the failing scenario and capture exact output
3. **Fill template** from `context/templates.md`

## For Bugs

1. Get reproduction steps from the user
2. Confirm the bug is reproducible in the current branch
3. Run `git --no-pager log --oneline -5 2>&1` — when was this introduced?

## For Features

1. Understand the user story: As a [role], I want [feature], so that [benefit]
2. Break down into acceptance criteria
3. Identify files that will need to change

## Output

Fill the ticket template and present it to the user for review before creating any issue in a tracker.
