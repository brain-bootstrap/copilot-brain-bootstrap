---
description: 'Generate tests for existing code. TDD-approach: Explore phase (read code), Plan phase (identify scenarios), Act phase (write tests). No implementation changes.'
mode: agent
tools:
  - read_file
  - create_file
  - replace_string_in_file
  - grep_search
  - file_search
  - run_in_terminal
argument-hint: '[file or function to test]'
---

Read `context/tasks/lessons.md` first — check for project-specific testing patterns.

## Phase 1 — Explore

1. Read the target file in full
2. Read an existing test file to understand the test framework and conventions
3. Identify all exported functions, methods, and classes
4. Note: error paths, edge cases, async behavior, dependencies

## Phase 2 — Plan

List test scenarios before writing any code:
- Happy path(s)
- Error paths (each throw/rejection)
- Edge cases (null, empty, boundary values)
- Async behavior

Present the plan and wait for approval.

## Phase 3 — Act

Write tests following the EXACT conventions of existing test files:
- Same imports style
- Same describe/it structure
- Same mock/stub patterns
- Same assertion library

Run tests after writing: `{{TEST_CMD_ALL}} 2>&1 | tail -20`

## Rules

- Never modify source code during test generation
- Never write tests that always pass regardless of implementation
- Mirror source file structure: `src/foo/bar.ts` → `src/foo/bar.test.ts`
