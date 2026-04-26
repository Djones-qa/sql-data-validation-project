-- CUSTOMERS (10 rows) - Issues: whitespace row 3, near-dupe email row 7, suspended row 9, NULL phone row 10
INSERT INTO customers (id, first_name, last_name, email, phone, created_at, status) VALUES
(1,  'John',    'Doe',       'john.doe@mail.com',       '555-0101', '2025-01-15 10:30:00', 'active'),
(2,  'Jane',    'Smith',     'jane.smith@mail.com',     '555-0102', '2025-02-20 14:00:00', 'active'),
(3,  '  Alice ', 'Johnson',  'alice.johnson@mail.com',  '555-0103', '2025-03-10 09:15:00', 'active'),
(4,  'Bob',     'Williams',  'bob.williams@mail.com',   '555-0104', '2025-03-22 11:45:00', 'active'),
(5,  'Carol',   'Brown',     'carol.brown@mail.com',    '555-0105', '2025-04-05 16:20:00', 'active'),
(6,  'David',   'Davis',     'david.davis@mail.com',    '555-0106', '2025-05-12 08:00:00', 'inactive'),
(7,  'John',    'Doe',       'johndoe@mail.com',        '555-0107', '2025-06-01 13:30:00', 'active'),
(8,  'Eva',     'Martinez',  'eva.martinez@mail.com',   '555-0108', '2025-06-18 10:00:00', 'active'),
(9,  'Frank',   'Garcia',    'frank.garcia@mail.com',   '555-0109', '2025-07-04 12:00:00', 'suspended'),
(10, 'Grace',   'Lee',       'grace.lee@mail.com',       NULL,      '2025-07-20 15:45:00', 'active');

-- PRODUCTS (8 rows) - Issues: empty category row 5, outlier price row 8
INSERT INTO products (id, product_name, category, unit_price, stock_qty, created_at) VALUES
(1, 'Wireless Mouse',       'Electronics', 29.99,   150, '2025-01-01 00:00:00'),
(2, 'USB-C Hub',            'Electronics', 49.99,   75,  '2025-01-01 00:00:00'),
(3, 'Cotton T-Shirt',       'Clothing',    19.99,   300, '2025-01-01 00:00:00'),
(4, 'Running Shoes',        'Clothing',    89.99,   60,  '2025-01-01 00:00:00'),
(5, 'Desk Lamp',            '',            34.99,   100, '2025-01-01 00:00:00'),
(6, 'Throw Pillow Set',     'Home',        24.99,   200, '2025-01-01 00:00:00'),
(7, 'Python Crash Course',  'Books',       39.99,   80,  '2025-01-01 00:00:00'),
(8, 'Diamond Pendant',      'Electronics', 499.99, 5,   '2025-01-01 00:00:00');

-- ORDERS (12 rows) - Issues: zero total row 4, NULL address row 11
INSERT INTO orders (id, customer_id, order_date, status, total_amount, shipping_address, created_at) VALUES
(1,  1, '2025-03-01', 'delivered',  79.97,  '123 Main St, Sandusky, OH 44870',   '2025-03-01 10:00:00'),
(2,  2, '2025-03-15', 'delivered',  89.99,  '456 Oak Ave, Cleveland, OH 44101',   '2025-03-15 11:00:00'),
(3,  3, '2025-04-02', 'shipped',    69.97,  '789 Elm St, Toledo, OH 43601',       '2025-04-02 09:30:00'),
(4,  4, '2025-04-10', 'pending',    64.97,   '321 Pine Rd, Columbus, OH 43201',    '2025-04-10 14:00:00'),
(5,  5, '2025-04-20', 'delivered',  164.95, '654 Birch Ln, Akron, OH 44301',      '2025-04-20 16:00:00'),
(6,  1, '2025-05-01', 'cancelled',  29.99,  '123 Main St, Sandusky, OH 44870',   '2025-05-01 08:00:00'),
(7,  6, '2025-05-15', 'delivered',  49.99,  '987 Cedar Dr, Dayton, OH 45401',     '2025-05-15 10:30:00'),
(8,  7, '2025-06-01', 'shipped',    39.98,  '147 Maple Ct, Cincinnati, OH 45201', '2025-06-01 12:00:00'),
(9,  8, '2025-06-10', 'pending',    24.99,  '258 Walnut Way, Canton, OH 44701',   '2025-06-10 09:00:00'),
(10, 9, '2025-06-20', 'pending',    39.99,  '369 Spruce Pl, Youngstown, OH 44501','2025-06-20 11:00:00'),
(11, 10,'2025-07-01', 'shipped',    75.98,  NULL,                                  '2025-07-01 14:00:00'),
(12, 2, '2025-07-10', 'delivered',  49.98,  '456 Oak Ave, Cleveland, OH 44101',   '2025-07-10 15:30:00');

-- ORDER ITEMS (20 rows) - Issue: row 14 price mismatch (45.99 vs catalog 49.99)
INSERT INTO order_items (id, order_id, product_id, quantity, unit_price) VALUES
(1,  1, 1, 2, 29.99),
(2,  2, 4, 1, 89.99),
(3,  3, 3, 2, 19.99),
(4,  3, 1, 1, 29.99),
(5,  4, 6, 1, 24.99),
(6,  5, 7, 2, 39.99),
(7,  5, 3, 1, 19.99),
(8,  5, 5, 1, 34.99),
(9,  6, 1, 1, 29.99),
(10, 7, 2, 1, 49.99),
(11, 8, 3, 2, 19.99),
(12, 9, 6, 1, 24.99),
(13, 10, 7, 1, 39.99),
(14, 11, 2, 1, 45.99),
(15, 11, 1, 1, 29.99),
(16, 12, 1, 1, 29.99),
(17, 12, 3, 1, 19.99),
(18, 1, 3, 1, 19.99),
(19, 5, 1, 1, 29.99),
(20, 4, 3, 2, 19.99);
