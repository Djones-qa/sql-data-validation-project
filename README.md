# SQL Data Validation Project

A lightweight SQLite-based data validation project for an e-commerce-style dataset. The repository includes schema definition, seeded example data, validation scripts, and a pytest suite for data-quality checks.

## Repository Structure

- `schema/`
  - `create_tables.sql` — database schema creation SQL
  - `seed_data.sql` — initial seeded data for validation
- `data/`
  - `validation.db` — generated SQLite database file (rebuildable)
- `scripts/`
  - `setup_db.py` — generate `validation.db` from schema and seed data
  - `run_validations.py` — execute validation checks and log results
- `tests/`
  - `test_data_quality.py` — pytest tests for core data quality rules
- `queries/`
  - reusable SQL queries for analytics, cleaning, and validation
- `docs/`
  - project documentation, checklist, and notes
- `requirements.txt` — Python dependencies

## Prerequisites

- Windows PowerShell
- Python 3.10+ installed
- A virtual environment configured in `.venv`
- `pytest` available in the virtual environment

## Setup

Open PowerShell and run:

```powershell
Set-ExecutionPolicy -Scope Process -ExecutionPolicy RemoteSigned
cd D:\sql-data-validation-project
& .\.venv\Scripts\Activate.ps1
python .\scripts\setup_db.py
```

This will:
- activate the project virtual environment
- generate or rebuild `data\validation.db`
- create all tables and seed the database

## Run Validations

To execute the built-in data validation checks:

```powershell
cd D:\sql-data-validation-project
& .\.venv\Scripts\Activate.ps1
python .\scripts\run_validations.py
```

The script will run a set of SQL checks, print pass/fail results, write to `validation_log`, and exit with status `0` if all checks pass.

## Run Tests

Run the pytest suite:

```powershell
cd D:\sql-data-validation-project
& .\.venv\Scripts\Activate.ps1
pytest -q
```

If you want to rebuild the database before the tests, run:

```powershell
cd D:\sql-data-validation-project
& .\.venv\Scripts\Activate.ps1
python .\scripts\setup_db.py
pytest -q
```

## GitHub Push Commands

Use these commands from the repository root to commit and push changes to GitHub:

```powershell
cd D:\sql-data-validation-project
& .\.venv\Scripts\Activate.ps1

# initialize git if needed
git init

git status

git add .

git commit -m "Add README and update validation workflow"

git branch -M main

git remote add origin https://github.com/<your-username>/<your-repo>.git

git push -u origin main
```

If you already have a remote configured, use:

```powershell
git add .
git commit -m "Update README and validation scripts"
git push
```

## Notes

- `data\validation.db` is a generated file and may be excluded from version control if desired.
- Validation checks include: null checks, uniqueness, price and quantity ranges, referential integrity, future dates, and order total accuracy.
- The project is intentionally seeded with edge-case issues to demonstrate validation coverage.

## Tips

- If running on a fresh machine, ensure `.venv` is created and dependencies are installed with `python -m pip install -r requirements.txt`.
- If the database file is stale, rerun `python .\scripts\setup_db.py` before validations or tests.
