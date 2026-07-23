CREATE VIEW vw_order_revenue AS
SELECT
  o.order_id, o.order_date::date AS order_day, o.customer_id, o.store_id,
  sum(oi.quantity * oi.unit_price)::numeric(12,2) AS order_revenue
FROM sales_order o
JOIN sales_order_item oi ON oi.order_id = o.order_id
WHERE o.status = 'paid'
GROUP BY o.order_id, o.order_date::date, o.customer_id, o.store_id;

CREATE VIEW vw_daily_sales AS
SELECT
  r.order_day, s.store_name,
  count(*) AS paid_orders,
  sum(r.order_revenue)::numeric(12,2) AS revenue,
  round(avg(r.order_revenue), 2) AS average_order_value
FROM vw_order_revenue r
JOIN store s ON s.store_id = r.store_id
GROUP BY r.order_day, s.store_name;
