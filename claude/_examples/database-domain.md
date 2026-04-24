<!-- EXAMPLE: Delete this file after reading. Create your own domain docs following this pattern. -->

# Database Domain — Example

> This is a **worked example** of a domain knowledge doc for database patterns. Replace with your actual DB domain.

## Database Architecture

- **Primary DB**: PostgreSQL 16 (or MySQL, MongoDB, SQLite — document yours)
- **ORM / Query Builder**: Prisma / Knex.js / SQLAlchemy / GORM
- If using multiple DBs (read replica + write primary), document which is used where

## Schema Model

### Core Tables

| Table         | Purpose         | Key columns                                         |
| ------------- | --------------- | --------------------------------------------------- |
| `users`       | User accounts   | `id`, `email`, `role`, `created_at`                 |
| `orders`      | Business orders | `id`, `user_id`, `status`, `total`, `created_at`    |
| `order_items` | Line items      | `id`, `order_id`, `product_id`, `quantity`, `price` |
| `products`    | Product catalog | `id`, `name`, `sku`, `price`, `stock`               |

### Key Relationships

```
users 1──────N orders
orders 1──────N order_items
products 1──────N order_items
```

## Migration Patterns

- Migration tool: Knex / Prisma / Alembic / Flyway (document yours)
- Never mix DDL and DML in the same migration
- Always test rollback: `migrate up` → `rollback` → `migrate up`
- Column names: `snake_case`, scoped by table, no redundant prefixes

## Common Query Patterns

- Use parameterized queries — never string concatenation for SQL
- Pagination: cursor-based for large tables, offset for small admin lists
- Soft deletes via `deleted_at` timestamp — never `DELETE` production data without explicit policy
