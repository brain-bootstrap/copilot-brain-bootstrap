<!-- EXAMPLE: Delete this file after reading. Create your own domain docs following this pattern. -->

# API Domain — Example

> This is a **worked example** of a domain knowledge doc for a REST API layer. Replace with your actual API domain.

## Endpoints Overview

| Method | Path                        | Purpose                 | Auth         |
| ------ | --------------------------- | ----------------------- | ------------ |
| `POST` | `/api/v1/orders`            | Create a new order      | Bearer token |
| `GET`  | `/api/v1/orders/:id`        | Get order by ID         | Bearer token |
| `PUT`  | `/api/v1/orders/:id/status` | Update order status     | Admin role   |
| `GET`  | `/api/v1/orders`            | List orders (paginated) | Bearer token |

## Request Validation

- All endpoints use **Zod** (TypeScript) / **Pydantic** (Python) for input validation
- Validation happens at the controller layer, before service logic
- `.strict()` mode rejects undeclared keys silently — always test with extra fields

## Error Handling Pattern

```
Controller → validate input → Service → Repository → DB
                                ↓ (on error)
                          ErrorBuilder.from(error)
                                ↓
                          Standardized error response
```

- 400: Validation errors (field-level details in response body)
- 401: Missing or invalid auth token
- 403: Insufficient permissions
- 404: Resource not found
- 409: Conflict (duplicate resource)
- 500: Unexpected server error (logged, not exposed to client)

## Auth Patterns

- JWT Bearer tokens in `Authorization: Bearer <token>` header
- Token refresh via `/api/v1/auth/refresh` (short-lived access + long-lived refresh)
- Admin routes require `role: 'admin'` claim in JWT payload
