---
name: cross-layer-check
description: 'Cross-layer consistency check. Ensures new fields, enums, and types are consistent across all layers: DB → repository → service → DTO → validator → API response → tests.'
user-invocable: true
---

# Cross-Layer Check Skill

## Purpose

Prevent cross-layer inconsistency — the #1 source of runtime bugs in multi-layer architectures.

## Protocol

When a new field, enum value, or type is added:

### 1. Identify all layers it touches

```
DB schema → migration → repository → entity/model → service → mapper → DTO → validator → API response → client types → tests
```

### 2. Search each layer

For each new field name (e.g., `userStatus`):
```bash
grep -rn 'userStatus\|user_status' --color=never . 2>/dev/null | head -30
```

### 3. Verify consistency

| Layer | File | Field name | Type | Required? |
|-------|------|------------|------|-----------|
| DB schema | migration/xxx.sql | `user_status` | VARCHAR(20) | YES |
| Repository | repo/user.ts | `userStatus` | string | YES |
| Service | service/user.ts | `userStatus` | UserStatus | YES |
| DTO | dto/user.dto.ts | `userStatus` | UserStatusEnum | YES |
| API response | api/user.ts | `user_status` | string | YES |

### 4. Flag inconsistencies

Any layer that is missing the field or uses a different type → 🔴 Must Fix

## Common Failure Patterns

- Field exists in DB but not in DTO → returns undefined to client
- Enum value added in code but not in DB constraint → runtime error
- Field renamed in service but not in tests → false positives
- New field in API response but not in API schema/docs → drift
