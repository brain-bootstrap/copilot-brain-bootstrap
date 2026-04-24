---
applyTo: '**/*.ts,**/*.tsx,tsconfig.json'
---

# TypeScript Conventions

> Path-scoped: auto-loaded when editing TypeScript or TSConfig files.

- **`strict: true`** — no exceptions; `noImplicitAny`, `strictNullChecks`, `strictFunctionTypes` all on
- **`unknown` over `any`** — use `unknown` and narrow at boundaries; ban `any` except for third-party shims
- **Interfaces for object shapes** — `interface Foo {}` not `type Foo = {}` for objects; use `type` for unions/intersections
- **`const` over `let`** — default to `const`; only `let` when reassignment is required
- **Zod at input boundaries** — parse untrusted data (API responses, user input, env vars) with Zod before use
- **Optional chaining** — `obj?.prop?.nested` not nested `if (obj && obj.prop)` checks
- **Return type annotations** — always annotate public function return types; omit for trivial private helpers
- **Avoid barrel re-exports** — `export * from './foo'` causes tree-shaking failures and circular-import bugs
