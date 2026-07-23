# Retail Analytics Warehouse

A PostgreSQL analytics project for a multi-store retailer. It models orders, products, customers and stores, then exposes reporting-ready views and KPI queries.

## What this demonstrates

- Relational modelling, constraints, indexes and transactional data integrity
- Dimensional reporting with reusable views and window functions
- Idempotent migrations and seed data
- Reproducible local setup with Docker

## Architecture

```text
Source systems -> PostgreSQL OLTP tables -> analytics views -> BI / analyst queries
                       |                         |
                    migrations                 KPI scripts
```

The `sales_order` / `sales_order_item` tables are normalized for write safety. Analytics views intentionally denormalize that data for consumers.

## Run it

```bash
docker compose up -d
docker compose exec db psql -U retail -d retail_analytics -f /workspace/db/queries.sql
```

PostgreSQL is available on `localhost:5434`. To reset local data, run `docker compose down -v` and start again.

## Repository map

| Path | Purpose |
| --- | --- |
| `db/migrations/001_schema.sql` | schema, constraints and indexes |
| `db/migrations/002_analytics_views.sql` | consumer-facing reporting views |
| `db/seeds/001_demo_data.sql` | deterministic demo data |
| `db/queries.sql` | portfolio KPI queries |
| `docs/architecture.md` | design decisions and scale-up path |
| `docs/interview-guide.md` | interview questions with model answers |

## Example KPIs

- Monthly revenue and order counts
- Top products per category using `DENSE_RANK`
- Repeat-customer rate using cohort-style aggregation
- 30-day rolling revenue using a window function

## Quality decisions

- Monetary values use `numeric(12,2)`, never floating point.
- Order item prices are captured at purchase time, so later catalog price changes do not rewrite history.
- Foreign keys use restrictive defaults to prevent deleting referenced business records.
- The main reporting join is indexed through foreign keys and `(order_date, status)`.

## Push to GitHub

```bash
git init
git add . && git commit -m "feat: add retail analytics warehouse"
git branch -M main
git remote add origin https://github.com/YOUR_USERNAME/sql-retail-analytics.git
git push -u origin main
```

See [architecture](docs/architecture.md) and the [interview guide](docs/interview-guide.md).
