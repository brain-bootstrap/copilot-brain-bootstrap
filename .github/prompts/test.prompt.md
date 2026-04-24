---
description: 'Run test suite. Read context/build.md for test commands. Report pass/fail with exact counts. Fix failures.'
agent: agent
tools:
  - read_file
  - run_in_terminal
  - grep_search
argument-hint: '[optional: specific test file or test name pattern]'
---

Read `context/build.md` first to get the exact test commands.

## Test Protocol

1. Run: `{{TEST_CMD_ALL}} 2>&1 | tail -40`
2. If a pattern was provided: `{{TEST_CMD_SINGLE}} 2>&1 | tail -40`
3. Report:
   - ✅ X tests passed, 0 failed
   - ❌ X failed — list failing test names

## On Failure

1. Read the failing test output
2. Determine: is this a test bug or a code bug?
3. If code bug → apply the debug protocol (Iron Law: root cause first)
4. If test bug → fix the test to reflect the correct expected behavior
5. Re-run to confirm fix
6. Re-run full suite to confirm no regressions
