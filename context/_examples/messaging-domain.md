<!-- EXAMPLE: Delete this file after reading. Create your own domain docs following this pattern. -->

# Messaging / Event-Driven Domain — Example

> This is a **worked example** of a domain knowledge doc for event-driven architecture. Replace with your actual messaging domain.

## Message Broker

- **Broker**: Kafka / RabbitMQ / Redis Pub/Sub / AWS SQS / NATS (document yours)
- **Client library**: KafkaJS / amqplib / ioredis (document yours)

## Topics / Queues

| Topic/Queue         | Producer(s)       | Consumer(s)                             | Purpose              |
| ------------------- | ----------------- | --------------------------------------- | -------------------- |
| `order-created`     | order-service     | notification-service, inventory-service | New order event      |
| `payment-completed` | payment-service   | order-service                           | Payment confirmation |
| `inventory-updated` | inventory-service | catalog-service                         | Stock change         |

## Message Format

```json
{
  "eventType": "ORDER_CREATED",
  "timestamp": "2026-01-01T00:00:00Z",
  "correlationId": "uuid-v7",
  "payload": {
    "orderId": "uuid",
    "userId": "uuid",
    "items": []
  }
}
```

## Transaction Safety — THE #1 RULE

> **NEVER emit messages inside a DB transaction.**

A DB transaction can roll back, but a sent message cannot be unsent. This creates data inconsistency.
Use the **transactional outbox pattern**: write events to an `outbox` table inside the transaction, then
a separate process reads and publishes them.

## Consumer Error Handling

- **Idempotency**: consumers must handle duplicate delivery gracefully
- **Dead-letter queue**: failed messages after N retries go to DLQ for manual review
- **Poison pill**: log and skip messages that consistently fail deserialization
