# Retail Analytics

MySQL 8 retail analytics project with normalized order data, reporting views, seed data, and KPI queries.

```bash
docker compose up -d
docker compose exec -T db mysql -uretail -pretail retail_analytics < db/queries.sql
```

MySQL runs on `localhost:3307`.
