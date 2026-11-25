# Retail Sales SQL Assessment

**SQL portfolio project | MySQL 8.0 | DB Fiddle**

## Project overview
This project analyses a retail chain operating six stores across North, South, and West.
It covers data cleaning, region standardisation, duplicate removal, relationship validation,
regional and store-level sales analysis, and return-category analysis for October 2026.

## Tools and environment
- **Online SQL platform:** DB Fiddle (Online SQL Playground)
- **Database engine:** MySQL 8.0
- **SQL topics:** DDL, DML, joins, aggregation, CTE/window-style analysis, data cleaning,
  date filtering, ranking and business interpretation
- **Presentation:** Microsoft PowerPoint

## Repository structure
```text
retail-sales-sql-portfolio/
├── README.md
├── sql/
│   ├── execution_order/
│   │   ├── 00_create_starter_tables.sql
│   │   ├── 01_question_01_standardize_regions.sql
│   │   ├── 02_question_02_deduplicate_order_lines.sql
│   │   ├── 03_question_04_matching_customers.sql
│   │   ├── 04_question_05_unmatched_customer_ids.sql
│   │   ├── 05_question_06_customers_without_orders.sql
│   │   ├── 06_question_07_multiple_returns.sql
│   │   ├── 07_question_08_regional_sales_and_returns.sql
│   │   ├── 08_question_10_store_comparison.sql
│   │   └── 09_question_11_return_category_analysis.sql
│   ├── All_Questions_1_to_11_Query_Only.sql
│   └── reference/
│       └── All_Questions_1_to_11.sql
├── diagrams/
│   ├── ER_Diagram.png
│   └── ER_Diagram.mmd
├── outputs/
│   ├── Query_Outputs.docx
│   ├── Business_Case_Presentation.pptx
│   └── screenshots/
├── docs/
│   └── Completed_Worksheet.docx
└── data/
    └── README_DATASET_REQUIRED.md
```

## How to run
1. Open [DB Fiddle](https://www.db-fiddle.com/) and choose **MySQL 8.0**.
2. Run `sql/execution_order/00_create_starter_tables.sql` to create the six starter tables.
3. Load the original assessment dataset into those tables.
4. Run the scripts in `sql/execution_order/` in ascending filename order.
5. Question 3 is the ER diagram deliverable (`diagrams/ER_Diagram.png`).
6. Question 9 is a written comparison based on Question 8 results.
7. Open `outputs/Query_Outputs.docx` to review the recorded outputs and
   `outputs/Business_Case_Presentation.pptx` for the one-slide management summary.

### Important dataset limitation
The source worksheet refers to an attached dataset, but that dataset was not among the
three files provided for this package. The package includes the table-creation script and
all assessment SQL, but a clean run from an empty database requires the original dataset
to be imported after step 2. See `data/README_DATASET_REQUIRED.md`.

## Key findings (October 2026)
- Gross sales: **$42,757.75** across **190 completed orders**.
- Return value: **$4,131.75**; net sales: **$38,626.00**.
- North led gross sales at **$14,389.25**.
- South led net sales at **$13,037.00**, exceeding North by **$210.00**.
- Electronics accounted for **$669.00 (42.82%)** of North's return value.
- Cedar Market led the South region with **$7,112.50** net sales.

## Recommendation
Investigate the high Electronics return value in the North region, strengthen product-quality
and return-prevention checks, and study Cedar Market's sales practices for approaches that
could be replicated across other stores.

## Deliverables checklist
- [x] Completed worksheet
- [x] Numbered SQL scripts arranged in execution order
- [x] Consolidated SQL query-only file for Questions 1–11
- [x] Query output document and extracted screenshots
- [x] ER diagram (PNG and editable Mermaid source)
- [x] One-slide PowerPoint business summary
- [x] Platform and database engine documented

## Notes
The SQL files preserve the query logic and outputs documented in the submitted worksheet.
`OrderItems_Clean` is created from the raw `OrderItems` table in Question 2, keeping the
latest `LoadedAt` record for each `OrderItemID`.
