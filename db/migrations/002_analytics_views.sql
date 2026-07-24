CREATE VIEW vw_order_revenue AS
SELECT
  o.order_id, DATE(o.order_date) AS order_day, o.customer_id, o.store_id,
  CAST(SUM(oi.quantity * oi.unit_price) AS DECIMAL(12,2)) AS order_revenue
FROM sales_order o
JOIN sales_order_item oi ON oi.order_id = o.order_id
WHERE o.status = 'paid'
GROUP BY o.order_id, DATE(o.order_date), o.customer_id, o.store_id;

CREATE VIEW vw_daily_sales AS
SELECT
  r.order_day, s.store_name,
  count(*) AS paid_orders,
  CAST(SUM(r.order_revenue) AS DECIMAL(12,2)) AS revenue,
  ROUND(AVG(r.order_revenue), 2) AS average_order_value
FROM vw_order_revenue r
JOIN store s ON s.store_id = r.store_id
GROUP BY r.order_day, s.store_name;
