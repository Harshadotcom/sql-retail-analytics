-- 1. Monthly revenue. Cancelled/refunded orders are excluded by the view.
SELECT date_trunc('month', order_day)::date AS month, sum(order_revenue) AS revenue, count(*) AS orders
FROM vw_order_revenue GROUP BY 1 ORDER BY 1;

-- 2. Top 2 products in every category by revenue.
WITH product_sales AS (
  SELECT p.category, p.product_name, sum(oi.quantity * oi.unit_price) AS revenue
  FROM sales_order o JOIN sales_order_item oi USING(order_id) JOIN product p USING(product_id)
  WHERE o.status = 'paid' GROUP BY 1,2
), ranked AS (
  SELECT *, dense_rank() OVER (PARTITION BY category ORDER BY revenue DESC) AS revenue_rank FROM product_sales
)
SELECT category, product_name, revenue, revenue_rank FROM ranked WHERE revenue_rank <= 2 ORDER BY category, revenue_rank;

-- 3. Repeat-customer rate: customers with more than one paid order / all paid customers.
WITH customer_orders AS (
 SELECT customer_id, count(*) AS paid_order_count FROM vw_order_revenue GROUP BY customer_id
)
SELECT round(100.0 * count(*) FILTER (WHERE paid_order_count > 1) / nullif(count(*), 0), 2) AS repeat_customer_pct
FROM customer_orders;

-- 4. Daily revenue and 30-day rolling revenue.
WITH daily AS (SELECT order_day, sum(order_revenue) AS revenue FROM vw_order_revenue GROUP BY 1)
SELECT order_day, revenue, sum(revenue) OVER (ORDER BY order_day RANGE BETWEEN INTERVAL '29 days' PRECEDING AND CURRENT ROW) AS rolling_30_day_revenue
FROM daily ORDER BY order_day;

-- 5. recursive_category_revenue.sql
WITH RECURSIVE category_tree AS (
    -- Anchor member: top-level categories (no parent)
    SELECT
        category_id,
        name,
        parent_category_id,
        category_id AS root_category_id
    FROM product_category
    WHERE parent_category_id IS NULL

    UNION ALL

    -- Recursive member: each child inherits its ancestor's root category
    SELECT
        c.category_id,
        c.name,
        c.parent_category_id,
        ct.root_category_id
    FROM product_category c
    JOIN category_tree ct ON c.parent_category_id = ct.category_id
)

SELECT
    root.name                              AS top_level_category,
    SUM(oi.quantity * oi.unit_price)::numeric(12,2) AS total_revenue
FROM category_tree ct
JOIN product_category root ON ct.root_category_id = root.category_id
JOIN product p              ON p.category_id = ct.category_id
JOIN sales_order_item oi    ON oi.product_id = p.product_id
GROUP BY root.name
ORDER BY total_revenue DESC;
