-- 1. Revenue by Category
SELECT p.category, SUM(oi.line_total) AS total_revenue, COUNT(DISTINCT oi.order_id) AS order_count
FROM order_items oi JOIN products p ON oi.product_id = p.id
GROUP BY p.category ORDER BY total_revenue DESC;

-- 2. Top 5 Customers by Spend
WITH customer_spend AS (
    SELECT c.id, c.first_name || ' ' || c.last_name AS customer_name, c.email,
           SUM(o.total_amount) AS total_spent, COUNT(o.id) AS order_count
    FROM customers c JOIN orders o ON c.id = o.customer_id
    WHERE o.status != 'cancelled' GROUP BY c.id
)
SELECT customer_name, email, total_spent, order_count,
       RANK() OVER (ORDER BY total_spent DESC) AS spend_rank
FROM customer_spend ORDER BY total_spent DESC LIMIT 5;

-- 3. Monthly Order Trend
SELECT strftime('%Y-%m', order_date) AS order_month, COUNT(*) AS order_count,
       SUM(total_amount) AS monthly_revenue
FROM orders WHERE status != 'cancelled' GROUP BY order_month ORDER BY order_month;

-- 4. Running Total Revenue
SELECT id, order_date, total_amount,
       SUM(total_amount) OVER (ORDER BY order_date, id) AS running_total
FROM orders WHERE status != 'cancelled' ORDER BY order_date, id;

-- 5. Order Status Distribution
SELECT status, COUNT(*) AS status_count,
       ROUND(COUNT(*) * 100.0 / (SELECT COUNT(*) FROM orders), 1) AS pct
FROM orders GROUP BY status ORDER BY status_count DESC;

-- 6. Average Order Value vs Median
SELECT ROUND(AVG(total_amount), 2) AS avg_order_value,
       (SELECT total_amount FROM (
           SELECT total_amount, ROW_NUMBER() OVER (ORDER BY total_amount) AS rn,
                  COUNT(*) OVER () AS total_rows
           FROM orders WHERE status != 'cancelled' AND total_amount > 0
       ) WHERE rn = (total_rows + 1) / 2) AS approx_median
FROM orders WHERE status != 'cancelled' AND total_amount > 0;

-- 7. Products Never Ordered
SELECT p.id, p.product_name, p.category, p.unit_price
FROM products p LEFT JOIN order_items oi ON p.id = oi.product_id WHERE oi.id IS NULL;

-- 8. Customer Retention Indicator
SELECT CASE WHEN order_count > 1 THEN 'Repeat Buyer' ELSE 'Single Order' END AS customer_type,
       COUNT(*) AS customer_count
FROM (SELECT customer_id, COUNT(*) AS order_count FROM orders
      WHERE status != 'cancelled' GROUP BY customer_id)
GROUP BY customer_type;
