# Interview guide

## Why store unit price on the order item instead of reading product.current_price?

Product price is mutable catalog data; an order is an immutable business event. Storing the price at checkout preserves financial history and makes reporting reproducible. Discounts could be represented by `discount_amount` or a separate adjustment table.

## Why a view instead of duplicating a reporting table?

A view keeps the initial system simple and always current. If query volume grows, a materialized view or incremental aggregate trades some freshness for predictable performance. I would choose based on dashboard latency and freshness requirements.

## Explain `DENSE_RANK` here.

It ranks products within each category by revenue. Tied revenues share a rank and the next rank is not skipped, so “top 2” represents two revenue positions fairly. `ROW_NUMBER` would arbitrarily break ties unless a secondary sort were intentional.

## How would you prevent two users from overselling inventory?

Put inventory and reservation logic in one database transaction. Lock the inventory row with `SELECT ... FOR UPDATE` (or use a conditional decrement), verify available quantity, create the reservation, then commit. Add idempotency keys for retry-safe checkout requests.

## How would you debug a slow dashboard?

Capture the exact SQL and parameters, inspect `EXPLAIN ANALYZE`, then check selectivity, stale statistics, sort/hash spill, and index usage. I would fix the query or targeted index first; only then consider a materialized aggregate or partitioning.
