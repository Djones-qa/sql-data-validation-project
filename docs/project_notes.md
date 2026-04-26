# Project Notes

## Design Decisions
- **SQLite** - Portable, zero-config, reviewers can clone and run immediately.
- **E-Commerce Domain** - Relatable, rich validation scenarios, mirrors real pipelines.
- **Normalized Schema** - Foreign keys between customers, orders, order_items, products.

## Intentional Data Issues
| Issue                  | Location                | Purpose                              |
|------------------------|-------------------------|--------------------------------------|
| Leading/trailing space | customers.first_name    | Tests TRIM operations                |
| Empty string category  | products.category       | Tests NULL vs empty string handling   |
| Outlier price 9999.99  | products.unit_price     | Tests range validation               |
| Future order date      | orders.order_date       | Tests business rule validation        |
| Zero total_amount      | orders.total_amount     | Tests recalculation logic             |
| Price mismatch         | order_items.unit_price  | Tests catalog consistency             |
| NULL shipping address  | orders.shipping_address | Tests completeness checks             |
| Near-duplicate emails  | customers.email         | Tests deduplication                   |

## Future Enhancements
- Data profiling with pandas
- dbt-style data tests
- Cohort analysis and RFM segmentation
- CI dashboard with GitHub Pages or Streamlit
