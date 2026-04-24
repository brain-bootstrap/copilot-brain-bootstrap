---
description: 'Run build. Read claude/build.md for exact commands. Report pass/fail with logs.'
mode: agent
tools:
  - read_file
  - run_in_terminal
argument-hint: '[optional: service name for single-service build]'
---

Read `claude/build.md` first to get the exact build commands.

## Build Protocol

1. Run: `{{BUILD_CMD_ALL}} 2>&1 | tail -30`
2. If a service name was provided: `{{BUILD_CMD_SINGLE}} 2>&1 | tail -30`
3. Report:
   - ✅ Build passed
   - ❌ Build failed — paste relevant error lines (max 20 lines)

## On Failure

1. Read the error carefully
2. Identify the root cause (missing dependency? compile error? type error?)
3. Fix the issue
4. Re-run build to confirm
5. If the fix requires >3 file changes, run `/plan` first
