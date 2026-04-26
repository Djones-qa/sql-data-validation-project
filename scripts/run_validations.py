"""Run all validation checks, log results, and exit with appropriate code."""
import sqlite3, sys
from pathlib import Path

SCRIPT_DIR = Path(__file__).resolve().parent
PROJECT_ROOT = SCRIPT_DIR.parent
DB_PATH = PROJECT_ROOT / "data" / "validation.db"

CHECKS = [
    ("NOT_NULL_customer_email",          "SELECT * FROM customers WHERE email IS NULL;"),
    ("NOT_NULL_order_date",              "SELECT * FROM orders WHERE order_date IS NULL;"),
    ("UNIQUE_customer_email",            "SELECT email, COUNT(*) FROM customers GROUP BY LOWER(email) HAVING COUNT(*) > 1;"),
    ("RANGE_product_price",              "SELECT * FROM products WHERE unit_price <= 0 OR unit_price > 5000;"),
    ("RANGE_order_quantity",             "SELECT * FROM order_items WHERE quantity <= 0 OR quantity > 100;"),
    ("REF_INTEGRITY_orders",             "SELECT o.* FROM orders o LEFT JOIN customers c ON o.customer_id = c.id WHERE c.id IS NULL;"),
    ("REF_INTEGRITY_order_items_orders", "SELECT oi.* FROM order_items oi LEFT JOIN orders o ON oi.order_id = o.id WHERE o.id IS NULL;"),
    ("REF_INTEGRITY_order_items_products","SELECT oi.* FROM order_items oi LEFT JOIN products p ON oi.product_id = p.id WHERE p.id IS NULL;"),
    ("BUSINESS_future_orders",           "SELECT * FROM orders WHERE order_date > date('now');"),
    ("BUSINESS_total_mismatch",          "SELECT o.id, o.total_amount, SUM(oi.line_total) AS calc_total FROM orders o JOIN order_items oi ON o.id = oi.order_id GROUP BY o.id HAVING ABS(o.total_amount - SUM(oi.line_total)) > 0.01;"),
]

def main():
    if not DB_PATH.exists():
        print(f"ERROR: Database not found at {DB_PATH}"); sys.exit(1)
    conn = sqlite3.connect(str(DB_PATH))
    conn.execute("PRAGMA foreign_keys = ON;")
    cur = conn.cursor()
    any_fail = False
    print("\n" + "=" * 62)
    print(f"  {'Check Name':<42} {'Result':<8} {'Rows':>6}")
    print("=" * 62)
    for name, sql in CHECKS:
        cur.execute(sql)
        rows = cur.fetchall()
        result = "PASS" if len(rows) == 0 else "FAIL"
        if result == "FAIL": any_fail = True
        print(f"  {name:<42} {result:<8} {len(rows):>6}")
        cur.execute("INSERT INTO validation_log (check_name, check_sql, result, record_count) VALUES (?,?,?,?);",
                    (name, sql, result, len(rows)))
    conn.commit()
    total = len(CHECKS)
    passed = sum(1 for n, s in CHECKS if len([cur.execute(s), cur.fetchall()][1]) == 0)
    print("=" * 62)
    print(f"\n  Summary: {passed}/{total} passed, {total - passed} failed\n")
    conn.close()
    sys.exit(1 if any_fail else 0)

if __name__ == "__main__":
    main()
