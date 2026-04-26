CREATE TABLE IF NOT EXISTS customers (
    id          INTEGER PRIMARY KEY,
    first_name  TEXT    NOT NULL,
    last_name   TEXT    NOT NULL,
    email       TEXT    UNIQUE NOT NULL,
    phone       TEXT,
    created_at  TEXT    DEFAULT (datetime('now')),
    status      TEXT    CHECK(status IN ('active','inactive','suspended')) DEFAULT 'active'
);

CREATE TABLE IF NOT EXISTS products (
    id            INTEGER PRIMARY KEY,
    product_name  TEXT    NOT NULL,
    category      TEXT    NOT NULL,
    unit_price    REAL   NOT NULL CHECK(unit_price > 0),
    stock_qty     INTEGER NOT NULL DEFAULT 0 CHECK(stock_qty >= 0),
    created_at    TEXT    DEFAULT (datetime('now'))
);

CREATE TABLE IF NOT EXISTS orders (
    id                INTEGER PRIMARY KEY,
    customer_id       INTEGER NOT NULL REFERENCES customers(id),
    order_date        TEXT    NOT NULL,
    status            TEXT    CHECK(status IN ('pending','shipped','delivered','cancelled')) DEFAULT 'pending',
    total_amount      REAL   CHECK(total_amount >= 0),
    shipping_address  TEXT,
    created_at        TEXT    DEFAULT (datetime('now'))
);

CREATE TABLE IF NOT EXISTS order_items (
    id          INTEGER PRIMARY KEY,
    order_id    INTEGER NOT NULL REFERENCES orders(id),
    product_id  INTEGER NOT NULL REFERENCES products(id),
    quantity    INTEGER NOT NULL CHECK(quantity > 0),
    unit_price  REAL    NOT NULL CHECK(unit_price > 0),
    line_total  REAL    GENERATED ALWAYS AS (quantity * unit_price) STORED
);

CREATE TABLE IF NOT EXISTS validation_log (
    id            INTEGER PRIMARY KEY,
    check_name    TEXT    NOT NULL,
    check_sql     TEXT,
    result        TEXT    CHECK(result IN ('PASS','FAIL','WARN')),
    record_count  INTEGER,
    run_at        TEXT    DEFAULT (datetime('now'))
);
