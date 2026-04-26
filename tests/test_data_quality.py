"""Pytest data quality test suite."""
import sqlite3
import subprocess
import sys
from pathlib import Path
import pytest

PROJECT_ROOT = Path(__file__).resolve().parent.parent
DB_PATH = PROJECT_ROOT / "data" / "validation.db"
SETUP_SCRIPT = PROJECT_ROOT / "scripts" / "setup_db.py"

@pytest.fixture(scope="session")
def db():
    if not DB_PATH.exists():
        subprocess.run([sys.executable, str(SETUP_SCRIPT)], check=True)
    assert DB_PATH.exists(), f"Database not found at {DB_PATH}. Run setup_db.py first."
    conn = sqlite3.connect(str(DB_PATH))
    conn.execute("PRAGMA foreign_keys = ON;")
    yield conn.cursor()
    conn.close()

def test_no_null_emails(db):
    db.execute("SELECT * FROM customers WHERE email IS NULL;")
    assert len(db.fetchall()) == 0, "Found customers with NULL email"

def test_unique_emails(db):
    db.execute("SELECT email, COUNT(*) FROM customers GROUP BY LOWER(email) HAVING COUNT(*) > 1;")
    assert len(db.fetchall()) == 0, "Found duplicate emails"

def test_valid_price_range(db):
    db.execute("SELECT * FROM products WHERE unit_price <= 0 OR unit_price > 5000;")
    assert len(db.fetchall()) == 0, "Found products with price out of range"

def test_referential_integrity_orders(db):
    db.execute("SELECT o.* FROM orders o LEFT JOIN customers c ON o.customer_id = c.id WHERE c.id IS NULL;")
    assert len(db.fetchall()) == 0, "Found orders referencing non-existent customers"

def test_no_future_orders(db):
    db.execute("SELECT * FROM orders WHERE order_date > date('now');")
    assert len(db.fetchall()) == 0, "Found orders with future dates"

def test_order_total_accuracy(db):
    db.execute("SELECT o.id FROM orders o JOIN order_items oi ON o.id = oi.order_id GROUP BY o.id HAVING ABS(o.total_amount - SUM(oi.line_total)) > 0.01;")
    assert len(db.fetchall()) == 0, "Found orders with total mismatch"
