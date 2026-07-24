SELECT DATE_FORMAT(order_day, '%Y-%m-01') AS month, SUM(order_revenue) AS revenue, COUNT(*) AS orders
FROM vw_order_revenue GROUP BY DATE_FORMAT(order_day, '%Y-%m-01') ORDER BY month;

WITH product_sales AS (
  SELECT p.category, p.product_name, SUM(oi.quantity * oi.unit_price) AS revenue
  FROM sales_order o JOIN sales_order_item oi USING(order_id) JOIN product p USING(product_id)
  WHERE o.status = 'paid' GROUP BY p.category, p.product_name
), ranked AS (
  SELECT *, DENSE_RANK() OVER (PARTITION BY category ORDER BY revenue DESC) AS revenue_rank FROM product_sales
)
SELECT category, product_name, revenue, revenue_rank FROM ranked WHERE revenue_rank <= 2 ORDER BY category, revenue_rank;

WITH customer_orders AS (
 SELECT customer_id, COUNT(*) AS paid_order_count FROM vw_order_revenue GROUP BY customer_id
)
SELECT ROUND(100 * AVG(paid_order_count > 1), 2) AS repeat_customer_pct
FROM customer_orders;

WITH daily AS (SELECT order_day, SUM(order_revenue) AS revenue FROM vw_order_revenue GROUP BY order_day)
SELECT d1.order_day, d1.revenue,
  (SELECT SUM(d2.revenue) FROM daily d2 WHERE d2.order_day BETWEEN DATE_SUB(d1.order_day, INTERVAL 29 DAY) AND d1.order_day) AS rolling_30_day_revenue
FROM daily d1 ORDER BY d1.order_day;
