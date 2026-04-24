---
applyTo: '**/routes/**,**/controllers/**,**/middleware/**,**/middlewares/**,**/handlers/**,**/usecases/**,**/workers/**,**/server/**,**/api/**,**/src/**,**/app/**,**/lib/**,**/core/**,**/domain/**,**/config/**'
---

# Node.js Backend Conventions

> Path-scoped: auto-loaded for server-side Node.js code.

- **Typed route handlers** — every route parameter, query string, and body must be typed; no implicit `any`
- **Repository pattern** — data access lives in `*Repository` classes; controllers never call DB directly
- **Zod at route boundary** — validate and parse all incoming request data with Zod before touching business logic
- **Correct HTTP status codes** — 201 for resource creation, 204 for no-content, 400 for validation errors, 401 for auth, 403 for permissions, 404 for not-found, 409 for conflicts, 422 for semantic errors, 500 for unexpected
- **Structured logging** — use pino or winston with `{ level, msg, ...context }` objects; no bare `console.log` in production
- **Async error middleware** — always add `next(err)` in async handlers and a global error middleware at the end of the chain
- **Rate limiting on auth routes** — apply rate limiting to `/login`, `/register`, `/forgot-password` and similar routes
- **NEVER side effects in DB transactions** — no external calls (HTTP, queue, email) inside a transaction; use deferred callbacks or outbox pattern
