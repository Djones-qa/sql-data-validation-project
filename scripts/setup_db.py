"""Build the SQLite database from schema and seed files."""
import sqlite3
from pathlib import Path

SCRIPT_DIR = Path(__file__).resolve().parent
PROJECT_ROOT = SCRIPT_DIR.parent
DB_PATH = PROJECT_ROOT / "data" / "validation.db"
SCHEMA_PATH = PROJECT_ROOT / "schema" / "create_tables.sql"
SEED_PATH = PROJECT_ROOT / "schema" / "seed_data.sql"

def main():
    DB_PATH.parent.mkdir(parents=True, exist_ok=True)
    if DB_PATH.exists():
        DB_PATH.unlink()
        print(f"Removed existing database: {DB_PATH}")
    schema_sql = SCHEMA_PATH.read_text(encoding="utf-8")
    seed_sql = SEED_PATH.read_text(encoding="utf-8")
    conn = sqlite3.connect(str(DB_PATH))
    try:
        conn.execute("PRAGMA foreign_keys = ON;")
        conn.executescript(schema_sql)
        conn.executescript(seed_sql)
        conn.commit()
        cursor = conn.execute("SELECT name FROM sqlite_master WHERE type='table' ORDER BY name;")
        tables = [row[0] for row in cursor.fetchall()]
        print(f"Database created at {DB_PATH}")
        print(f"Tables ({len(tables)}): {', '.join(tables)}")
    finally:
        conn.close()

if __name__ == "__main__":
    main()
