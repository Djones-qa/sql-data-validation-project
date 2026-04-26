# Data Validation Checklist

## 1. Schema Integrity
- [ ] All tables created without errors
- [ ] Primary keys defined on every table
- [ ] Foreign key relationships enforced
- [ ] CHECK constraints on status fields and numeric ranges
- [ ] NOT NULL constraints on required fields
- [ ] UNIQUE constraints on email

## 2. Data Completeness
- [ ] No NULL values in required fields
- [ ] No empty strings masquerading as valid data
- [ ] All orders have at least one order_item
- [ ] All order_items reference valid products

## 3. Data Accuracy
- [ ] Prices within range (0.01 - 5000)
- [ ] Quantities within range (1 - 100)
- [ ] Order totals match sum of line items
- [ ] No future-dated orders
- [ ] Email format validation

## 4. Data Consistency
- [ ] Customer status values in defined set
- [ ] Order status values in defined set
- [ ] Unit prices match product catalog
- [ ] Date formats consistent (ISO 8601)

## 5. Uniqueness
- [ ] No duplicate customer emails (case-insensitive)
- [ ] No duplicate order_item rows for same order + product
- [ ] Customer IDs unique

## 6. Referential Integrity
- [ ] Every order references a valid customer
- [ ] Every order_item references a valid order
- [ ] Every order_item references a valid product
- [ ] No orphaned records

## 7. Edge Cases
- [ ] Zero-quantity items rejected
- [ ] Negative prices rejected
- [ ] NULL handling consistent

## 8. Automation
- [ ] run_validations.py passes
- [ ] pytest suite passes
- [ ] GitHub Actions workflow runs on push/PR
- [ ] validation_log table populated
