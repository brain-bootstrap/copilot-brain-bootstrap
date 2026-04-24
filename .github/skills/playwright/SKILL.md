---
name: playwright
description: 'E2E testing with Playwright. Write, run, and debug browser automation tests. Supports visual regression, accessibility checks, and multi-browser testing.'
user-invocable: true
---

# Playwright Skill

## Requirements

Check `context/plugins.md` for Playwright installation status.

## Common Operations

### Run all E2E tests
```bash
npx playwright test 2>&1 | tail -30
```

### Run specific test
```bash
npx playwright test tests/auth.spec.ts 2>&1 | tail -30
```

### Run with UI mode (headed)
```bash
npx playwright test --headed 2>&1 | tail -20
```

### Debug a test
```bash
npx playwright test tests/foo.spec.ts --debug 2>&1 | tail -20
```

### Generate test
```bash
npx playwright codegen http://localhost:3000 2>&1 | tail -10
```

## Test Structure

```typescript
import { test, expect } from '@playwright/test';

test('user can login', async ({ page }) => {
  await page.goto('/login');
  await page.fill('[name=email]', 'user@example.com');
  await page.fill('[name=password]', 'password123');
  await page.click('button[type=submit]');
  await expect(page).toHaveURL('/dashboard');
});
```

## Best Practices

- Use `data-testid` attributes for selectors (not CSS classes)
- Never use `page.waitForTimeout()` — use `waitForSelector` or `waitForURL`
- Always assert on the final state, not intermediate states
