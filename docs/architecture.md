# Architecture notes

## Data flow

`sales_order` owns order-level facts; `sales_order_item` owns the product, quantity and **price at checkout**. This avoids updating historic revenue when a catalog price changes. Views filter to paid orders once, so dashboards cannot accidentally count cancellations.

## Why this design

The transactional tables are in third normal form: customers, products and stores have one authoritative row. Analytics needs a simpler read model, so views join and aggregate at query time. For a larger workload, I would materialize `vw_daily_sales`, refresh it on a schedule, and partition `sales_order` monthly by `order_date`.

## Performance and operations

Start with `EXPLAIN (ANALYZE, BUFFERS)` on slow reports. Indexes match common predicates and joins; they are not added blindly because writes also pay their cost. Migrations are ordered, versioned SQL. Backups would use point-in-time recovery plus a tested restore runbook.
