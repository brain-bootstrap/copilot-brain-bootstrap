---
name: tdd
description: 'Test-Driven Development skill. Automatically activates on test files. 3-phase protocol: Explore (understand existing tests), Plan (list scenarios), Act (write tests then implementation).'
user-invocable: false
paths:
  - '**/*.test.{ts,js,py,rs,go}'
  - '**/*.spec.{ts,js,py,rs,go}'
  - '**/test_*.py'
  - '**/*_test.go'
---

# TDD Skill

This skill activates automatically when working with test files.

## 3-Phase Protocol

### Phase 1: Explore (Read first, always)

1. Read the test file you are working in
2. Read 1-2 neighboring test files to understand project conventions
3. Identify: test framework, assertion style, mock patterns, fixtures

### Phase 2: Plan (List scenarios before writing)

For every function/method you are testing, list:
- Happy path(s)
- Error paths (each throw/rejection)
- Edge cases (null, empty, boundary values, concurrent)

**Do not proceed to Phase 3 until all scenarios are listed.**

### Phase 3: Act (Write tests, then implementation)

TDD order:
1. Write a failing test
2. Write the minimal implementation to make it pass
3. Refactor (don't break the test)

## Anti-patterns

- ❌ Writing implementation before tests
- ❌ Tests that pass regardless of implementation
- ❌ Skipping error path tests because "it probably won't happen"
- ❌ Mocking the function under test

## Conventions

- Mirror source structure: `src/foo/bar.ts` → `src/foo/bar.test.ts`
- Test names: describe behavior, not implementation — "returns null when user not found"
- One concept per test — don't test 3 things in one `it` block
