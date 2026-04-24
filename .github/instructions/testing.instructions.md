---
applyTo: '**/*.{test,spec}.{ts,js,py,rs,go}'
---

# Testing Standards

Apply these rules to ALL test files.

## Structure

- Mirror source file structure: `src/foo/bar.ts` → `src/foo/bar.test.ts`
- One describe block per module/class
- Test names describe behavior: "returns null when user not found", NOT "test1"

## Coverage

- Every exported function has at least one test
- Every error path has a test
- Every edge case (empty array, null, boundary values) has a test

## Anti-patterns

- ❌ No tests that always pass regardless of implementation
- ❌ No stubs without assertions on how they were called
- ❌ No `beforeAll` that mutates shared state across test groups
- ❌ No `expect(true).toBe(true)` placeholder tests

## Assertions

- Assert the specific value, not just "it doesn't throw"
- Use `toEqual` for objects, `toBe` for primitives
- Test failure messages should explain what was expected vs received

## Test Isolation

- Each test sets up its own fixtures
- Each test tears down its own side effects
- No shared state between tests unless explicitly documented
