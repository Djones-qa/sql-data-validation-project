-- ===== Check 1: Trim Whitespace in Customer Names =====
SELECT id, first_name, last_name FROM customers
WHERE first_name != TRIM(first_name) OR last_name != TRIM(last_name);

UPDATE customers SET first_name = TRIM(first_name), last_name = TRIM(last_name)
WHERE first_name != TRIM(first_name) OR last_name != TRIM(last_name);

-- ===== Check 2: Standardize Empty Strings to NULL =====
SELECT id, product_name, category FROM products WHERE category = '' OR category IS NULL;
UPDATE products SET category = NULL WHERE category = '';
UPDATE orders SET shipping_address = NULL WHERE shipping_address = '';

-- ===== Check 3: Detect Duplicate Emails =====
SELECT LOWER(REPLACE(email, '.', '')) AS normalized_email,
       GROUP_CONCAT(id) AS customer_ids,
       GROUP_CONCAT(email) AS original_emails,
       COUNT(*) AS occurrences
FROM customers GROUP BY normalized_email HAVING COUNT(*) > 1;

-- ===== Check 4: Flag Future-Dated Orders =====
SELECT id, customer_id, order_date, status, total_amount
FROM orders WHERE order_date > date('now');

-- ===== Check 5: Fix Zero or NULL Totals =====
SELECT o.id, o.total_amount, SUM(oi.line_total) AS calculated_total
FROM orders o JOIN order_items oi ON o.id = oi.order_id
WHERE o.total_amount = 0 OR o.total_amount IS NULL GROUP BY o.id;

UPDATE orders SET total_amount = (
    SELECT SUM(oi.line_total) FROM order_items oi WHERE oi.order_id = orders.id
) WHERE total_amount = 0 OR total_amount IS NULL;

-- ===== Check 6: Orphan Check =====
SELECT oi.* FROM order_items oi LEFT JOIN orders o ON oi.order_id = o.id WHERE o.id IS NULL;
SELECT oi.* FROM order_items oi LEFT JOIN products p ON oi.product_id = p.id WHERE p.id IS NULL;

-- ===== Check 7: Price Discrepancy Detection =====
SELECT oi.id AS order_item_id, oi.order_id, oi.product_id, p.product_name,
       oi.unit_price AS charged_price, p.unit_price AS catalog_price,
       (oi.unit_price - p.unit_price) AS price_difference
FROM order_items oi JOIN products p ON oi.product_id = p.id
WHERE ABS(oi.unit_price - p.unit_price) > 0.01;
