-- NOT_NULL_customer_email
SELECT * FROM customers WHERE email IS NULL;

-- NOT_NULL_order_date
SELECT * FROM orders WHERE order_date IS NULL;

-- UNIQUE_customer_email
SELECT email, COUNT(*) AS cnt FROM customers GROUP BY LOWER(email) HAVING COUNT(*) > 1;

-- RANGE_product_price
SELECT * FROM products WHERE unit_price <= 0 OR unit_price > 5000;

-- RANGE_order_quantity
SELECT * FROM order_items WHERE quantity <= 0 OR quantity > 100;

-- REF_INTEGRITY_orders
SELECT o.* FROM orders o LEFT JOIN customers c ON o.customer_id = c.id WHERE c.id IS NULL;

-- REF_INTEGRITY_order_items_orders
SELECT oi.* FROM order_items oi LEFT JOIN orders o ON oi.order_id = o.id WHERE o.id IS NULL;

-- REF_INTEGRITY_order_items_products
SELECT oi.* FROM order_items oi LEFT JOIN products p ON oi.product_id = p.id WHERE p.id IS NULL;

-- BUSINESS_future_orders
SELECT * FROM orders WHERE order_date > date('now');

-- BUSINESS_total_mismatch
SELECT o.id, o.total_amount, SUM(oi.line_total) AS calc_total
FROM orders o JOIN order_items oi ON o.id = oi.order_id
GROUP BY o.id HAVING ABS(o.total_amount - SUM(oi.line_total)) > 0.01;
